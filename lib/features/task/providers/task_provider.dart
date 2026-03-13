/// Task providers
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itpapp/shared/models/task.dart';
import 'package:itpapp/core/network/mock/mock_api_service.dart';

/// Get all tasks
final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final response = await MockApiService.getTasks();

  if (response['success'] == true) {
    final tasksList = response['data']['tasks'] as List?;
    return tasksList?.map((task) => Task.fromJson(task as Map<String, dynamic>)).toList() ?? [];
  }

  return [];
});

/// Get task detail
final taskDetailProvider = FutureProvider.family<Task, String>((ref, taskId) async {
  final response = await MockApiService.getTaskDetail(taskId);

  if (response['success'] == true) {
    return Task.fromJson(response['data'] as Map<String, dynamic>);
  }

  throw Exception('Task not found');
});

/// Filter tasks by status
final tasksFilteredProvider = Provider.family<List<Task>, TaskStatus?>((ref, status) {
  final tasksAsync = ref.watch(tasksProvider);

  return tasksAsync.when(
    data: (tasks) {
      if (status == null) return tasks;
      return tasks.where((task) => task.status == status).toList();
    },
    loading: () => [],
    error: (_, _) => [],
  );
});

/// Task stats provider
final taskStatsProvider = Provider((ref) {
  final tasksAsync = ref.watch(tasksProvider);

  return tasksAsync.when(
    data: (tasks) {
      return {
        'total': tasks.length,
        'new': tasks.where((t) => t.status == TaskStatus.newTask).length,
        'inProgress': tasks.where((t) => t.status == TaskStatus.inProgress).length,
        'overdue': tasks.where((t) => t.status == TaskStatus.overdue).length,
        'completed': tasks.where((t) => t.status == TaskStatus.completed).length,
      };
    },
    loading: () => {'total': 0, 'new': 0, 'inProgress': 0, 'overdue': 0, 'completed': 0},
    error: (_, _) => {'total': 0, 'new': 0, 'inProgress': 0, 'overdue': 0, 'completed': 0},
  );
});

/// Create and manage tasks
class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  TaskNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> createTask(Task task) async {
    state = const AsyncValue.loading();
    try {
      final response = await MockApiService.createTask(task);
      if (response['success'] == true) {
        state = const AsyncValue.data(null);
        // Small delay to ensure the mock data is updated
        await Future.delayed(const Duration(milliseconds: 100));
        // Invalidate the tasks provider to refresh the list
        ref.invalidate(tasksProvider);
      } else {
        state = AsyncValue.error(Exception('Failed to create task'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final taskNotifierProvider = StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  return TaskNotifier(ref);
});
