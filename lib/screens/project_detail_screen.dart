import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import '../providers/project_provider.dart';
import '../pdf_export_helper.dart'; // Import the PDF helper

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final project = projectProvider.getProjectById(projectId);

    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Proyecto no encontrado')),
        body: const Center(child: Text('El proyecto solicitado no existe.')),
      );
    }

    final grandTotal = project.jobs.fold(0.0, (sum, job) => sum + job.totalCost);

    return Scaffold(
      appBar: AppBar(
        title: Text(project.projectName),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              await Printing.sharePdf(bytes: await generatePdf(project), filename: '${project.projectName}_presupuesto.pdf');
            },
            tooltip: 'Exportar a PDF',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cliente: ${project.clientName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Región: ${project.region}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const Text(
              'Partidas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: project.jobs.isEmpty
                  ? const Center(child: Text('No hay partidas añadidas a este proyecto.'))
                  : ListView.builder(
                      itemCount: project.jobs.length,
                      itemBuilder: (context, index) {
                        final job = project.jobs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(job.workType.description),
                            subtitle: Text(
                                '${job.dimensions} - ${job.workType.unit} | Costo: ${job.totalCost.toStringAsFixed(2)} Bs'),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'GRAN TOTAL: ${grandTotal.toStringAsFixed(2)} Bs',
                style: Theme.of(context).textTheme.headlineSmall!,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () => context.go('/project/$projectId/select_item'),
              icon: const Icon(Icons.add),
              label: const Text('Añadir Partida'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
