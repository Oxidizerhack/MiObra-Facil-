import 'package:flutter/material.dart';
import '../services/sync_service.dart';
import '../config/api_config.dart';

/// Pantalla de sincronización con MySQL Cloud
class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final SyncService _syncService = SyncService();
  
  bool _isSyncing = false;
  SyncStats? _stats;
  String? _lastSyncMessage;
  
  @override
  void initState() {
    super.initState();
    _loadStats();
  }
  
  /// Carga las estadísticas de sincronización
  Future<void> _loadStats() async {
    final stats = await _syncService.getSyncStats();
    setState(() {
      _stats = stats;
    });
  }
  
  /// Ejecuta la sincronización
  Future<void> _performSync() async {
    setState(() {
      _isSyncing = true;
      _lastSyncMessage = null;
    });
    
    try {
      final result = await _syncService.syncAll();
      
      setState(() {
        _lastSyncMessage = result.message;
      });
      
      // Recargar estadísticas
      await _loadStats();
      
      if (result.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Sincronizado: ${result.uploaded} subidos, ${result.downloaded} descargados'
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${result.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }
  
  /// Verifica la conexión al servidor
  Future<void> _testConnection() async {
    setState(() {
      _isSyncing = true;
    });
    
    try {
      final isHealthy = await _syncService.checkServerHealth();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isHealthy ? '✅ Servidor respondiendo correctamente' : '❌ Servidor no disponible'
            ),
            backgroundColor: isHealthy ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error de conexión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronización Cloud'),
        backgroundColor: const Color(0xFF004E89),
      ),
      body: _stats == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Estado de conexión
                  _buildConnectionCard(),
                  const SizedBox(height: 16),
                  
                  // Estadísticas
                  _buildStatsCard(),
                  const SizedBox(height: 16),
                  
                  // Configuración
                  _buildConfigCard(),
                  const SizedBox(height: 16),
                  
                  // Última sincronización
                  if (_lastSyncMessage != null)
                    _buildLastSyncCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Botones de acción
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }
  
  /// Card de estado de conexión
  Widget _buildConnectionCard() {
    final hasConnection = _stats!.hasConnection;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasConnection ? Icons.cloud_done : Icons.cloud_off,
                  color: hasConnection ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estado de Conexión',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Internet',
              hasConnection ? 'Conectado' : 'Sin conexión',
              hasConnection ? Colors.green : Colors.red,
            ),
            _buildInfoRow(
              'Tipo',
              _stats!.connectionType,
              Colors.blue,
            ),
            _buildInfoRow(
              'Servidor',
              ApiConfig.baseUrl,
              Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
  
  /// Card de estadísticas
  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Color(0xFF004E89)),
                const SizedBox(width: 8),
                Text(
                  'Estadísticas',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Proyectos locales (Hive)',
              '${_stats!.localProjects}',
              Colors.blue,
            ),
            _buildInfoRow(
              'Última sincronización',
              _stats!.lastSyncDescription,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
  
  /// Card de configuración
  Widget _buildConfigCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Color(0xFF004E89)),
                const SizedBox(width: 8),
                Text(
                  'Configuración',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Auto-sync al iniciar',
              ApiConfig.autoSyncOnStart ? 'Activado' : 'Desactivado',
              ApiConfig.autoSyncOnStart ? Colors.green : Colors.grey,
            ),
            _buildInfoRow(
              'Solo WiFi',
              ApiConfig.syncOnlyOnWifi ? 'Sí' : 'No',
              ApiConfig.syncOnlyOnWifi ? Colors.blue : Colors.grey,
            ),
            if (ApiConfig.autoSyncIntervalMinutes > 0)
              _buildInfoRow(
                'Intervalo auto-sync',
                '${ApiConfig.autoSyncIntervalMinutes} minutos',
                Colors.orange,
              ),
          ],
        ),
      ),
    );
  }
  
  /// Card de último mensaje de sincronización
  Widget _buildLastSyncCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(_lastSyncMessage!),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Botones de acción
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Botón principal de sincronización
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _isSyncing ? null : _performSync,
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.sync),
            label: Text(
              _isSyncing ? 'Sincronizando...' : 'Sincronizar Ahora',
              style: const TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004E89),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Botón de test de conexión
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isSyncing ? null : _testConnection,
            icon: const Icon(Icons.wifi_find),
            label: const Text('Probar Conexión al Servidor'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF004E89),
            ),
          ),
        ),
      ],
    );
  }
  
  /// Helper para crear filas de información
  Widget _buildInfoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
