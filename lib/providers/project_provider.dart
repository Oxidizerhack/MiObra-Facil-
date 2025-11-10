import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import '../models/job_model.dart';

class ProjectProvider with ChangeNotifier {
  final List<Project> _projects = [];
  List<Project> get projects => _projects;
  var uuid = const Uuid();

  void addProject(String projectName, String clientName, String region) {
    final newProject = Project(
      id: uuid.v4(),
      projectName: projectName,
      clientName: clientName,
      region: region,
    );
    _projects.add(newProject);
    notifyListeners();
  }

  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  void addJobToProject(String projectId, Job job) {
    final projectIndex =
        _projects.indexWhere((project) => project.id == projectId);
    if (projectIndex != -1) {
      final project = _projects[projectIndex];
      final updatedJobs = List<Job>.from(project.jobs)..add(job);
      _projects[projectIndex] = project.copyWith(jobs: updatedJobs);
      notifyListeners();
    }
  }
}
