/// Project providers
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/shared/models/project.dart';
import 'package:itpapp/core/network/mock/mock_api_service.dart';

/// Get all projects
final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final response = await MockApiService.getProjects();

  if (response['success'] == true) {
    final projectsList = response['data']['projects'] as List?;
    return projectsList
            ?.map((project) => Project.fromJson(project as Map<String, dynamic>))
            .toList() ??
        [];
  }

  return [];
});

/// Get active projects only
final activeProjectsProvider = FutureProvider<List<Project>>((ref) async {
  final allProjects = await ref.watch(projectsProvider.future);
  return allProjects.where((project) => project.status == ProjectStatus.active).toList();
});

/// Get project detail
final projectDetailProvider = FutureProvider.family<Project, String>((ref, projectId) async {
  final response = await MockApiService.getProjectDetail(projectId);

  if (response['success'] == true) {
    return Project.fromJson(response['data']['project'] as Map<String, dynamic>);
  }

  throw Exception('Project not found');
});

/// Get project team members
final projectTeamProvider = FutureProvider.family<List<String>, String>((ref, projectId) async {
  final project = await ref.watch(projectDetailProvider(projectId).future);
  return project.teamMembers;
});

/// Get project progress statistics
final projectStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  projectId,
) async {
  final response = await MockApiService.getProjectStats(projectId);

  if (response['success'] == true) {
    return response['data'] as Map<String, dynamic>;
  }

  return {'completedTasks': 0, 'totalTasks': 0, 'progress': 0, 'budget': 0.0, 'spent': 0.0};
});

/// Manage project operations
class ProjectNotifier extends StateNotifier<AsyncValue<void>> {
  ProjectNotifier() : super(const AsyncValue.data(null));

  Future<void> updateProject(Project project) async {
    state = const AsyncValue.loading();
    try {
      final response = await MockApiService.updateProject(project);
      if (response['success'] == true) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(Exception('Failed to update project'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final projectNotifierProvider = StateNotifierProvider<ProjectNotifier, AsyncValue<void>>((ref) {
  return ProjectNotifier();
});
