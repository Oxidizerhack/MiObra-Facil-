import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/project_model.dart';

Future<Uint8List> generatePdf(Project project) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => [
        pw.Header(
          level: 0,
          child: pw.Text(
            'Presupuesto: ${project.projectName}',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Cliente: ${project.clientName}'),
        pw.Text('Región: ${project.region}'),
        pw.SizedBox(height: 20),
        pw.Divider(),
        pw.SizedBox(height: 20),
        pw.Text(
          'Partidas:',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          context: context,
          data: <List<String>>[
            <String>[
              'Descripción',
              'Unidad',
              'Cantidad/Dimensiones',
              'Costo Total (Bs)',
            ],
            ...project.jobs.map(
              (job) => [
                job.workType.description,
                job.workType.unit,
                job.dimensions,
                job.totalCost.toStringAsFixed(2),
              ],
            ),
          ],
          cellAlignment: pw.Alignment.centerRight,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          border: pw.TableBorder.all(width: 0.5),
        ),
        pw.SizedBox(height: 20),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'GRAN TOTAL: ${project.jobs.fold(0.0, (sum, job) => sum + job.totalCost).toStringAsFixed(2)} Bs',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    ),
  );

  return pdf.save();
}
