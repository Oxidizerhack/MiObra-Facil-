import 'job_model.dart';

class Project {
  final String id;
  final String projectName;
  final String clientName;
  final String region;
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
