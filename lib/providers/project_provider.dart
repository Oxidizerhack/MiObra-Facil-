import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import '../models/job_model.dart';

class ProjectProvider with ChangeNotifier {
  late Box<Project> _projectBox;
  var uuid = const Uuid();

  ProjectProvider() {
    _projectBox = Hive.box<Project>('projects');
  }

  List<Project> get projects => _projectBox.values.toList();

  void addProject(String projectName, String clientName, String region) {
    final newProject = Project(
      id: uuid.v4(),
      projectName: projectName,
      clientName: clientName,
      region: region,
    );
    _projectBox.add(newProject);
    notifyListeners();
  }

  Project? getProjectById(String id) {
    try {
      return _projectBox.values.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  void addJobToProject(String projectId, Job job) {
    final projectIndex = _projectBox.values.toList().indexWhere((project) => project.id == projectId);
    if (projectIndex != -1) {
      final project = _projectBox.getAt(projectIndex)!;
      final updatedJobs = List<Job>.from(project.jobs)..add(job);
      final updatedProject = project.copyWith(jobs: updatedJobs);
      _projectBox.putAt(projectIndex, updatedProject);
      notifyListeners();
    }
  }

  void deleteProject(String id) {
    final projectIndex = _projectBox.values.toList().indexWhere((project) => project.id == id);
    if (projectIndex != -1) {
      _projectBox.deleteAt(projectIndex);
      notifyListeners();
    }
  }

  void updateProject(String id, String projectName, String clientName, String region) {
    final projectIndex = _projectBox.values.toList().indexWhere((project) => project.id == id);
    if (projectIndex != -1) {
      final project = _projectBox.getAt(projectIndex)!;
      final updatedProject = project.copyWith(
        projectName: projectName,
        clientName: clientName,
        region: region,
      );
      _projectBox.putAt(projectIndex, updatedProject);
      notifyListeners();
    }
  }

  void deleteJobFromProject(String projectId, int jobIndex) {
    final projectIndex = _projectBox.values.toList().indexWhere((project) => project.id == projectId);
    if (projectIndex != -1) {
      final project = _projectBox.getAt(projectIndex)!;
      final updatedJobs = List<Job>.from(project.jobs)..removeAt(jobIndex);
      final updatedProject = project.copyWith(jobs: updatedJobs);
      _projectBox.putAt(projectIndex, updatedProject);
      notifyListeners();
    }
  }

  void updateJobInProject(String projectId, int jobIndex, Job updatedJob) {
    final projectIndex = _projectBox.values.toList().indexWhere((project) => project.id == projectId);
    if (projectIndex != -1) {
      final project = _projectBox.getAt(projectIndex)!;
      final updatedJobs = List<Job>.from(project.jobs);
      updatedJobs[jobIndex] = updatedJob;
      final updatedProject = project.copyWith(jobs: updatedJobs);
      _projectBox.putAt(projectIndex, updatedProject);
      notifyListeners();
    }
  }
}
