import 'package:hive/hive.dart';

part 'work_type_model.g.dart';

@HiveType(typeId: 0)
class WorkType extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String description;
  
  @HiveField(2)
  final String unit;
  
  @HiveField(3)
  final Map<String, double> prices;

  WorkType({
    required this.id,
    required this.description,
    required this.unit,
    required this.prices,
  });
}
