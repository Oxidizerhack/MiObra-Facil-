import 'package:hive/hive.dart';
import 'job_model.dart';

part 'project_model.g.dart';

@HiveType(typeId: 2)
class Project extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String projectName;
  
  @HiveField(2)
  final String clientName;
  
  @HiveField(3)
  final String region;
  
  @HiveField(4)
  final List<Job> jobs;

  Project({
    required this.id,
    required this.projectName,
    required this.clientName,
    required this.region,
    this.jobs = const [],
  });

  Project copyWith({
    String? id,
    String? projectName,
    String? clientName,
    String? region,
    List<Job>? jobs,
  }) {
    return Project(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      clientName: clientName ?? this.clientName,
      region: region ?? this.region,
      jobs: jobs ?? this.jobs,
    );
  }
}
