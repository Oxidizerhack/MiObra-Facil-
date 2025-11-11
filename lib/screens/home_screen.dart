import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../providers/region_provider.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String _getRegionName(String regionKey) {
    const regionNames = {
      'laPaz': 'La Paz',
      'cochabamba': 'Cochabamba',
      'santaCruz': 'Santa Cruz',
      'sucre': 'Sucre',
      'oruro': 'Oruro',
      'tarija': 'Tarija',
      'potosi': 'Potosí',
    };
    return regionNames[regionKey] ?? regionKey;
  }

  void _showDeleteDialog(BuildContext context, String projectId, String projectName, ProjectProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar el proyecto "$projectName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                provider.deleteProject(projectId);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Proyecto eliminado exitosamente'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final regionProvider = Provider.of<RegionProvider>(context);

    final List<Widget> pages = [
      _buildProjectsList(context, projectProvider),
      const DashboardScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Mi Obra Fácil' : 'Dashboard'),
        actions: _selectedIndex == 0 ? [
          PopupMenuButton<String>(
            onSelected: (String region) {
              regionProvider.changeRegion(region);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'laPaz',
                child: Text('La Paz'),
              ),
              const PopupMenuItem<String>(
                value: 'cochabamba',
                child: Text('Cochabamba'),
              ),
              const PopupMenuItem<String>(
                value: 'santaCruz',
                child: Text('Santa Cruz'),
              ),
              const PopupMenuItem<String>(
                value: 'sucre',
                child: Text('Sucre'),
              ),
              const PopupMenuItem<String>(
                value: 'oruro',
                child: Text('Oruro'),
              ),
              const PopupMenuItem<String>(
                value: 'tarija',
                child: Text('Tarija'),
              ),
              const PopupMenuItem<String>(
                value: 'potosi',
                child: Text('Potosí'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  Text(_getRegionName(regionProvider.selectedRegion)),
                ],
              ),
            ),
          ),
        ] : null,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Proyectos',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Dashboard',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton.extended(
        onPressed: () => context.go('/add_project'),
        label: const Text('Nuevo Proyecto'),
        icon: const Icon(Icons.add),
      ) : null,
    );
  }

  Widget _buildProjectsList(BuildContext context, ProjectProvider projectProvider) {
    return projectProvider.projects.isEmpty
          ? const Center(
              child: Text('No hay proyectos. ¡Crea uno nuevo!'))
          : ListView.builder(
              itemCount: projectProvider.projects.length,
              itemBuilder: (context, index) {
                final project = projectProvider.projects[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(project.projectName),
                    subtitle: Text(project.clientName),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          context.go('/project/${project.id}/edit');
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, project.id, project.projectName, projectProvider);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => context.go('/project/${project.id}'),
                  ),
                );
              },
            );
  }
}
