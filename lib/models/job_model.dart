import 'package:hive/hive.dart';
import 'work_type_model.dart';

part 'job_model.g.dart';

@HiveType(typeId: 1)
class Job extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final WorkType workType;
  
  @HiveField(2)
  final double quantity;
  
  @HiveField(3)
  final String dimensions;
  
  @HiveField(4)
  final double totalCost;

  Job({
    required this.id,
    required this.workType,
    required this.quantity,
    required this.dimensions,
    required this.totalCost,
  });
}
