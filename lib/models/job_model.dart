import 'work_type_model.dart';

class Job {
  final String id;
  final WorkType workType;
  final double quantity;
  final String dimensions;
  final double totalCost;

  Job({
    required this.id,
    required this.workType,
    required this.quantity,
    required this.dimensions,
    required this.totalCost,
  });
}
