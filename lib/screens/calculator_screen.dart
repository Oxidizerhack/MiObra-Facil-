import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../data/work_types.dart';
import '../models/job_model.dart';
import '../providers/project_provider.dart';
// import '../providers/region_provider.dart'; // Removed as it's not used

class CalculatorScreen extends StatefulWidget {
  final String projectId;
  final String itemId;

  const CalculatorScreen({
    super.key,
    required this.projectId,
    required this.itemId,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController quantityController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  double _totalCost = 0.0;
  String _dimensions = '';

  @override
  void dispose() {
    quantityController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _calculateCost() {
    final workType = workTypes[widget.itemId]!;
    // final regionProvider = Provider.of<RegionProvider>(context, listen: false); // Removed as it's not used
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final project = projectProvider.getProjectById(widget.projectId)!;
    final price = workType.prices[project.region] ?? 0.0;

    double quantity = 0.0;
    if (workType.unit == 'm2' || workType.unit == 'm3') {
      final length = double.tryParse(lengthController.text) ?? 0.0;
      final width = double.tryParse(widthController.text) ?? 0.0;
      final height = double.tryParse(heightController.text) ?? 0.0;

      if (workType.unit == 'm2') {
        quantity = length * width;
        _dimensions = '${length}m x ${width}m';
      } else if (workType.unit == 'm3') {
        quantity = length * width * height;
        _dimensions = '${length}m x ${width}m x ${height}m';
      }
    } else {
      quantity = double.tryParse(quantityController.text) ?? 0.0;
      _dimensions = quantityController.text;
    }

    setState(() {
      _totalCost = quantity * price;
    });
  }

  @override
  Widget build(BuildContext context) {
    final workType = workTypes[widget.itemId]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(workType.description),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (workType.unit == 'm2') ...[
                TextFormField(
                  controller: lengthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Largo (m)', border: OutlineInputBorder()),
                  onChanged: (value) => _calculateCost(),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Ancho (m)', border: OutlineInputBorder()),
                  onChanged: (value) => _calculateCost(),
                ),
              ] else if (workType.unit == 'm3') ...[
                TextFormField(
                  controller: lengthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Largo (m)', border: OutlineInputBorder()),
                  onChanged: (value) => _calculateCost(),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: widthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Ancho (m)', border: OutlineInputBorder()),
                  onChanged: (value) => _calculateCost(),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Alto (m)', border: OutlineInputBorder()),
                  onChanged: (value) => _calculateCost(),
                ),
              ] else ...[
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad (${workType.unit})',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => _calculateCost(),
                ),
              ],
              const SizedBox(height: 24.0),
              Text(
                'Costo Total: ${_totalCost.toStringAsFixed(2)} Bs',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
                    final uuid = const Uuid();
                    final job = Job(
                      id: uuid.v4(),
                      workType: workType,
                      quantity: workType.unit == 'm2'
                          ? (double.tryParse(lengthController.text) ?? 0.0) *
                              (double.tryParse(widthController.text) ?? 0.0)
                          : workType.unit == 'm3'
                              ? (double.tryParse(lengthController.text) ?? 0.0) *
                                  (double.tryParse(widthController.text) ?? 0.0) *
                                  (double.tryParse(heightController.text) ?? 0.0)
                              : (double.tryParse(quantityController.text) ?? 0.0),
                      dimensions: _dimensions,
                      totalCost: _totalCost,
                    );
                    projectProvider.addJobToProject(widget.projectId, job);
                    context.go('/project/${widget.projectId}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Añadir al Presupuesto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
