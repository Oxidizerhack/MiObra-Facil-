import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../models/project_model.dart';
import '../providers/project_provider.dart';

/// Pantalla para visualizar información de la base de datos
/// Útil para demostrar al docente que los datos están persistidos
class DatabaseViewerScreen extends StatelessWidget {
  const DatabaseViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final box = Hive.box<Project>('projects');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor de Base de Datos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Información General de la BD
          _buildInfoCard(
            'Información de la Base de Datos',
            [
              _buildInfoRow('Motor de BD', 'Hive (NoSQL)'),
              _buildInfoRow('Tipo', 'Key-Value Store Local'),
              _buildInfoRow('Ubicación', '/data/data/com.example.mi_obra_facil/app_flutter/'),
              _buildInfoRow('Archivo principal', 'projects.hive'),
            ],
            Icons.storage,
            Colors.blue,
          ),

          const SizedBox(height: 16),

          // Estadísticas de la BD
          _buildInfoCard(
            'Estadísticas',
            [
              _buildInfoRow('Total Proyectos', box.length.toString()),
              _buildInfoRow('Total Partidas', _getTotalJobs(projectProvider).toString()),
              _buildInfoRow('Regiones activas', _getActiveRegions(projectProvider).toString()),
              _buildInfoRow('Tamaño estimado', '~${(box.length * 0.5).toStringAsFixed(1)} KB'),
            ],
            Icons.analytics,
            Colors.green,
          ),

          const SizedBox(height: 16),

          // Estructura de Tablas (TypeAdapters)
          _buildInfoCard(
            'Estructura de "Tablas" (TypeAdapters)',
            [
              _buildInfoRow('WorkType (TypeId: 0)', '26 tipos de trabajo'),
              _buildInfoRow('Job (TypeId: 1)', 'Partidas/Trabajos'),
              _buildInfoRow('Project (TypeId: 2)', 'Proyectos principales'),
            ],
            Icons.table_chart,
            Colors.orange,
          ),

          const SizedBox(height: 16),

          // Lista de Proyectos en BD
          Card(
            elevation: 4,
            child: ExpansionTile(
              leading: const Icon(Icons.folder_open, color: Colors.purple),
              title: const Text(
                'Proyectos en Base de Datos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${box.length} registros'),
              children: [
                ...box.values.map((project) => ListTile(
                  leading: CircleAvatar(
                    child: Text(project.projectName[0].toUpperCase()),
                  ),
                  title: Text(project.projectName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cliente: ${project.clientName}'),
                      Text('Región: ${project.region}'),
                      Text('ID: ${project.id}'),
                      Text('Partidas: ${project.jobs.length}'),
                    ],
                  ),
                  isThreeLine: true,
                )),
                if (box.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No hay proyectos en la base de datos',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Operaciones CRUD
          _buildInfoCard(
            'Operaciones CRUD Disponibles',
            [
              _buildInfoRow('CREATE', 'addProject() - Agregar nuevos proyectos'),
              _buildInfoRow('READ', 'getProjectById() - Leer proyectos'),
              _buildInfoRow('UPDATE', 'updateProject() - Actualizar datos'),
              _buildInfoRow('DELETE', 'deleteProject() - Eliminar proyectos'),
            ],
            Icons.code,
            Colors.teal,
          ),

          const SizedBox(height: 16),

          // Botón de prueba de persistencia
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Prueba de Persistencia'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Para demostrar la persistencia:'),
                      const SizedBox(height: 8),
                      const Text('1. Crea un proyecto'),
                      const Text('2. Cierra completamente la app (Force Stop)'),
                      const Text('3. Vuelve a abrir la app'),
                      const Text('4. El proyecto seguirá ahí ✅'),
                      const SizedBox(height: 16),
                      Text(
                        'Proyectos actuales: ${box.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Cómo Demostrar Persistencia'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          // Botón para exportar logs
          OutlinedButton.icon(
            onPressed: () {
              _printDatabaseInfo(box);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Información de BD impresa en consola (ver logcat)'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: const Icon(Icons.print),
            label: const Text('Imprimir Info en Consola (Debug)'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> rows, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalJobs(ProjectProvider provider) {
    return provider.projects.fold(0, (sum, project) => sum + project.jobs.length);
  }

  int _getActiveRegions(ProjectProvider provider) {
    final regions = provider.projects.map((p) => p.region).toSet();
    return regions.length;
  }

  void _printDatabaseInfo(Box<Project> box) {
    print('═══════════════════════════════════════');
    print('📊 INFORMACIÓN DE BASE DE DATOS - HIVE');
    print('═══════════════════════════════════════');
    print('');
    print('Motor: Hive (NoSQL Key-Value Store)');
    print('Archivo: projects.hive');
    print('Ubicación: /data/data/com.example.mi_obra_facil/app_flutter/');
    print('Total Proyectos: ${box.length}');
    print('');
    print('───────────────────────────────────────');
    print('REGISTROS EN BASE DE DATOS:');
    print('───────────────────────────────────────');
    
    if (box.isEmpty) {
      print('(No hay proyectos registrados)');
    } else {
      box.values.toList().asMap().forEach((index, project) {
        print('');
        print('Proyecto ${index + 1}:');
        print('  ID: ${project.id}');
        print('  Nombre: ${project.projectName}');
        print('  Cliente: ${project.clientName}');
        print('  Región: ${project.region}');
        print('  Partidas: ${project.jobs.length}');
        
        if (project.jobs.isNotEmpty) {
          print('  Trabajos:');
          project.jobs.forEach((job) {
            print('    - ${job.workType.description}: ${job.quantity} ${job.workType.unit} = ${job.totalCost.toStringAsFixed(2)} Bs');
          });
        }
      });
    }
    
    print('');
    print('═══════════════════════════════════════');
  }
}
