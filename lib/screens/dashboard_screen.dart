import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/project_provider.dart';
import '../models/project_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final projects = projectProvider.projects;

    // Calcular estadísticas
    final totalProjects = projects.length;
    final totalCost = projects.fold<double>(
      0.0,
      (sum, project) => sum + project.jobs.fold<double>(
        0.0,
        (jobSum, job) => jobSum + job.totalCost,
      ),
    );

    // Costos por categoría
    final Map<String, double> costsByCategory = {
      'Obra Gruesa': 0.0,
      'Obra Fina': 0.0,
      'Instalaciones': 0.0,
    };

    for (var project in projects) {
      for (var job in project.jobs) {
        final workTypeId = job.workType.id;
        if (workTypeId.startsWith('og_')) {
          costsByCategory['Obra Gruesa'] = (costsByCategory['Obra Gruesa'] ?? 0.0) + job.totalCost;
        } else if (workTypeId.startsWith('of_')) {
          costsByCategory['Obra Fina'] = (costsByCategory['Obra Fina'] ?? 0.0) + job.totalCost;
        } else if (workTypeId.startsWith('in_')) {
          costsByCategory['Instalaciones'] = (costsByCategory['Instalaciones'] ?? 0.0) + job.totalCost;
        }
      }
    }

    // Costos por región
    final Map<String, double> costsByRegion = {};
    final Map<String, int> projectsByRegion = {};
    
    for (var project in projects) {
      final region = _getRegionName(project.region);
      final projectCost = project.jobs.fold<double>(0.0, (sum, job) => sum + job.totalCost);
      costsByRegion[region] = (costsByRegion[region] ?? 0.0) + projectCost;
      projectsByRegion[region] = (projectsByRegion[region] ?? 0) + 1;
    }

    // Top 3 proyectos más costosos
    final sortedProjects = List<Project>.from(projects)
      ..sort((a, b) {
        final costA = a.jobs.fold<double>(0.0, (sum, job) => sum + job.totalCost);
        final costB = b.jobs.fold<double>(0.0, (sum, job) => sum + job.totalCost);
        return costB.compareTo(costA);
      });
    final topProjects = sortedProjects.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            tooltip: 'Sincronización Cloud',
            onPressed: () => context.go('/sync'),
          ),
          IconButton(
            icon: const Icon(Icons.storage),
            tooltip: 'Ver Base de Datos',
            onPressed: () => context.go('/database_viewer'),
          ),
        ],
      ),
      body: projects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay datos para mostrar',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea tu primer proyecto para ver estadísticas',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen general
                  _buildSummaryCards(context, totalProjects, totalCost),
                  
                  const SizedBox(height: 24),
                  
                  // Costos por categoría
                  _buildSectionTitle(context, 'Costos por Categoría'),
                  const SizedBox(height: 12),
                  _buildCategoryChart(context, costsByCategory, totalCost),
                  
                  const SizedBox(height: 24),
                  
                  // Distribución por región
                  _buildSectionTitle(context, 'Proyectos por Región'),
                  const SizedBox(height: 12),
                  _buildRegionStats(context, projectsByRegion, costsByRegion),
                  
                  const SizedBox(height: 24),
                  
                  // Top proyectos
                  _buildSectionTitle(context, 'Top 3 Proyectos'),
                  const SizedBox(height: 12),
                  _buildTopProjects(context, topProjects),
                ],
              ),
            ),
    );
  }

  String _getRegionName(String regionCode) {
    switch (regionCode) {
      case 'laPaz':
        return 'La Paz';
      case 'cochabamba':
        return 'Cochabamba';
      case 'santaCruz':
        return 'Santa Cruz';
      case 'sucre':
        return 'Sucre';
      case 'oruro':
        return 'Oruro';
      case 'tarija':
        return 'Tarija';
      case 'potosi':
        return 'Potosí';
      default:
        return regionCode;
    }
  }

  Widget _buildSummaryCards(BuildContext context, int totalProjects, double totalCost) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Total Proyectos',
            totalProjects.toString(),
            Icons.folder_open,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Inversión Total',
            '${totalCost.toStringAsFixed(0)} Bs',
            Icons.attach_money,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCategoryChart(BuildContext context, Map<String, double> costsByCategory, double totalCost) {
    final obraGruesa = costsByCategory['Obra Gruesa'] ?? 0.0;
    final obraFina = costsByCategory['Obra Fina'] ?? 0.0;
    final instalaciones = costsByCategory['Instalaciones'] ?? 0.0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCategoryBar(
              context,
              'Obra Gruesa',
              obraGruesa,
              totalCost,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildCategoryBar(
              context,
              'Obra Fina',
              obraFina,
              totalCost,
              Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildCategoryBar(
              context,
              'Instalaciones',
              instalaciones,
              totalCost,
              Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBar(BuildContext context, String category, double cost, double total, Color color) {
    final percentage = total > 0 ? (cost / total * 100) : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${cost.toStringAsFixed(0)} Bs',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage / 100,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRegionStats(BuildContext context, Map<String, int> projectsByRegion, Map<String, double> costsByRegion) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: projectsByRegion.entries.map((entry) {
            final region = entry.key;
            final projectCount = entry.value;
            final cost = costsByRegion[region] ?? 0.0;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getRegionColor(region).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.location_city,
                      color: _getRegionColor(region),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$projectCount ${projectCount == 1 ? 'proyecto' : 'proyectos'}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${cost.toStringAsFixed(0)} Bs',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getRegionColor(region),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getRegionColor(String region) {
    switch (region) {
      case 'La Paz':
        return Colors.blue;
      case 'Cochabamba':
        return Colors.green;
      case 'Santa Cruz':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildTopProjects(BuildContext context, List<Project> topProjects) {
    if (topProjects.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text('No hay proyectos para mostrar'),
          ),
        ),
      );
    }

    return Column(
      children: topProjects.asMap().entries.map((entry) {
        final index = entry.key;
        final project = entry.value;
        final totalCost = project.jobs.fold<double>(0.0, (sum, job) => sum + job.totalCost);
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getMedalColor(index),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              project.projectName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(project.clientName),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${totalCost.toStringAsFixed(0)} Bs',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getMedalColor(index),
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${project.jobs.length} partidas',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            onTap: () => context.go('/project/${project.id}'),
          ),
        );
      }).toList(),
    );
  }

  Color _getMedalColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber; // Oro
      case 1:
        return Colors.grey; // Plata
      case 2:
        return Colors.brown; // Bronce
      default:
        return Colors.blue;
    }
  }
}
