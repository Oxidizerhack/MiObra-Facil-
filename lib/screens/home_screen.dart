import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../providers/region_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final regionProvider = Provider.of<RegionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuesto Fácil'),
        actions: [
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
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  Text(regionProvider.selectedRegion),
                ],
              ),
            ),
          ),
        ],
      ),
      body: projectProvider.projects.isEmpty
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
                    onTap: () => context.go('/project/${project.id}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/add_project'),
        label: const Text('Nuevo Proyecto'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
