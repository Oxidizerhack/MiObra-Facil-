import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/project_model.dart';
import '../models/job_model.dart';
import '../models/work_type_model.dart';
import 'connectivity_service.dart';

/// Servicio de sincronización híbrida: Hive (local) ↔ MySQL (nube)
class SyncService {
  final ConnectivityService _connectivityService = ConnectivityService();
  
  // ==================== SINCRONIZACIÓN PRINCIPAL ====================
  
  /// Sincroniza todos los datos (bidireccional)
  Future<SyncResult> syncAll() async {
    final result = SyncResult();
    
    try {
      // 1. Verificar conexión
      if (!await _connectivityService.hasConnection()) {
        result.success = false;
        result.message = 'Sin conexión a internet';
        return result;
      }
      
      // 2. Verificar configuración de WiFi
      if (ApiConfig.syncOnlyOnWifi && !await _connectivityService.isWifi()) {
        result.success = false;
        result.message = 'Sincronización solo disponible con WiFi';
        return result;
      }
      
      // 3. Subir datos locales al servidor
      final uploadResult = await _uploadLocalChanges();
      result.uploaded = uploadResult.uploaded;
      result.uploadErrors = uploadResult.uploadErrors;
      
      // 4. Descargar datos del servidor
      final downloadResult = await _downloadRemoteChanges();
      result.downloaded = downloadResult.downloaded;
      result.downloadErrors = downloadResult.downloadErrors;
      
      // 5. Actualizar timestamp de última sincronización
      await _updateLastSyncTime();
      
      result.success = true;
      result.message = 'Sincronización completada';
      
    } catch (e) {
      result.success = false;
      result.message = 'Error en sincronización: $e';
      print('Error en syncAll: $e');
    }
    
    return result;
  }
  
  // ==================== SUBIR DATOS (LOCAL → NUBE) ====================
  
  /// Sube proyectos locales que no están sincronizados
  Future<SyncResult> _uploadLocalChanges() async {
    final result = SyncResult();
    
    try {
      final box = await Hive.openBox<Project>('projects');
      final projects = box.values.toList();
      
      for (var project in projects) {
        try {
          // Verificar si el proyecto ya existe en el servidor
          final exists = await _projectExistsOnServer(project.id);
          
          if (exists) {
            // Actualizar proyecto existente
            await _updateProjectOnServer(project);
          } else {
            // Crear nuevo proyecto
            await _createProjectOnServer(project);
          }
          
          result.uploaded++;
        } catch (e) {
          result.uploadErrors++;
          print('Error subiendo proyecto ${project.id}: $e');
        }
      }
      
    } catch (e) {
      print('Error en _uploadLocalChanges: $e');
    }
    
    return result;
  }
  
  /// Crea un proyecto en el servidor
  Future<void> _createProjectOnServer(Project project) async {
    final response = await http.post(
      Uri.parse(ApiConfig.projectsEndpoint),
      headers: ApiConfig.headers,
      body: jsonEncode(_projectToJson(project)),
    ).timeout(Duration(seconds: ApiConfig.requestTimeout));
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error creando proyecto: ${response.statusCode}');
    }
  }
  
  /// Actualiza un proyecto en el servidor
  Future<void> _updateProjectOnServer(Project project) async {
    final response = await http.put(
      Uri.parse(ApiConfig.projectByIdEndpoint(project.id)),
      headers: ApiConfig.headers,
      body: jsonEncode(_projectToJson(project)),
    ).timeout(Duration(seconds: ApiConfig.requestTimeout));
    
    if (response.statusCode != 200) {
      throw Exception('Error actualizando proyecto: ${response.statusCode}');
    }
  }
  
  /// Verifica si un proyecto existe en el servidor
  Future<bool> _projectExistsOnServer(String projectId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.projectByIdEndpoint(projectId)),
        headers: ApiConfig.headers,
      ).timeout(Duration(seconds: ApiConfig.requestTimeout));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // ==================== DESCARGAR DATOS (NUBE → LOCAL) ====================
  
  /// Descarga proyectos del servidor
  Future<SyncResult> _downloadRemoteChanges() async {
    final result = SyncResult();
    
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.projectsEndpoint),
        headers: ApiConfig.headers,
      ).timeout(Duration(seconds: ApiConfig.requestTimeout));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final box = await Hive.openBox<Project>('projects');
        
        for (var projectData in data) {
          try {
            final project = _projectFromJson(projectData);
            await box.put(project.id, project);
            result.downloaded++;
          } catch (e) {
            result.downloadErrors++;
            print('Error procesando proyecto: $e');
          }
        }
      }
    } catch (e) {
      print('Error en _downloadRemoteChanges: $e');
    }
    
    return result;
  }
  
  // ==================== CONVERSIÓN DE DATOS ====================
  
  /// Convierte Project a JSON para enviar al servidor
  Map<String, dynamic> _projectToJson(Project project) {
    return {
      'id': project.id,
      'name': project.projectName,
      'client': project.clientName,
      'location': project.region, // Usamos region como location
      'region': project.region,
      'created_at': DateTime.now().toIso8601String(),
      'device_id': ApiConfig.deviceId,
      'jobs': project.jobs.map((job) => {
        'id': job.id,
        'project_id': project.id,
        'work_type_id': job.workType.id,
        'work_type_name': job.workType.description,
        'quantity': job.quantity,
        'unit_price': job.workType.prices[project.region] ?? 0.0,
        'total': job.totalCost,
        'unit': job.workType.unit,
      }).toList(),
    };
  }
  
  /// Convierte JSON a Project
  Project _projectFromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      projectName: json['name'],
      clientName: json['client'],
      region: json['region'],
      jobs: (json['jobs'] as List<dynamic>?)
          ?.map((jobData) {
            // Necesitamos crear un WorkType básico desde los datos
            final workType = WorkType(
              id: jobData['work_type_id'],
              description: jobData['work_type_name'],
              unit: jobData['unit'],
              prices: {
                json['region']: (jobData['unit_price'] as num).toDouble(),
              },
            );
            
            return Job(
              id: jobData['id'],
              workType: workType,
              quantity: (jobData['quantity'] as num).toDouble(),
              dimensions: '${jobData['quantity']} ${jobData['unit']}',
              totalCost: (jobData['total'] as num).toDouble(),
            );
          })
          .toList() ?? [],
    );
  }
  
  // ==================== UTILIDADES ====================
  
  /// Verifica el estado del servidor
  Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.healthEndpoint),
        headers: ApiConfig.headers,
      ).timeout(Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error verificando servidor: $e');
      return false;
    }
  }
  
  /// Obtiene la última vez que se sincronizó
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('last_sync_timestamp');
    
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    
    return null;
  }
  
  /// Actualiza el timestamp de última sincronización
  Future<void> _updateLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_sync_timestamp', DateTime.now().millisecondsSinceEpoch);
  }
  
  /// Obtiene estadísticas de sincronización
  Future<SyncStats> getSyncStats() async {
    final stats = SyncStats();
    
    try {
      final box = await Hive.openBox<Project>('projects');
      stats.localProjects = box.length;
      
      final lastSync = await getLastSyncTime();
      stats.lastSyncTime = lastSync;
      
      if (lastSync != null) {
        final difference = DateTime.now().difference(lastSync);
        stats.hoursSinceLastSync = difference.inHours;
      }
      
      stats.hasConnection = await _connectivityService.hasConnection();
      stats.connectionType = await _connectivityService.getConnectionType();
      
    } catch (e) {
      print('Error obteniendo estadísticas: $e');
    }
    
    return stats;
  }
}

// ==================== CLASES DE RESULTADOS ====================

/// Resultado de una sincronización
class SyncResult {
  bool success = false;
  String message = '';
  int uploaded = 0;
  int downloaded = 0;
  int uploadErrors = 0;
  int downloadErrors = 0;
  
  @override
  String toString() {
    return 'SyncResult(success: $success, message: $message, '
           'uploaded: $uploaded, downloaded: $downloaded, '
           'uploadErrors: $uploadErrors, downloadErrors: $downloadErrors)';
  }
}

/// Estadísticas de sincronización
class SyncStats {
  int localProjects = 0;
  int remoteProjects = 0;
  DateTime? lastSyncTime;
  int hoursSinceLastSync = 0;
  bool hasConnection = false;
  String connectionType = 'Desconocido';
  
  String get lastSyncDescription {
    if (lastSyncTime == null) {
      return 'Nunca sincronizado';
    }
    
    if (hoursSinceLastSync == 0) {
      return 'Hace menos de 1 hora';
    } else if (hoursSinceLastSync < 24) {
      return 'Hace $hoursSinceLastSync hora(s)';
    } else {
      final days = hoursSinceLastSync ~/ 24;
      return 'Hace $days día(s)';
    }
  }
}
