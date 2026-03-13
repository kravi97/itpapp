/// Mock task data for development and testing
class TaskMockData {
  /// Mock tasks list with various statuses
  static List<Map<String, dynamic>> mockTasks = [
    {
      'taskId': 'TASK-001',
      'title': 'Design system UI components',
      'description': 'Create reusable UI components for the mobile app',
      'projectId': 'PROJ-001',
      'projectName': 'Mobile App Redesign',
      'status': 'In Progress',
      'priority': 'High',
      'category': 'Design',
      'estimatedHours': 8.0,
      'elapsedHours': 5.5,
      'elapsedSeconds': 19800, // 5.5 hours in seconds
      'startTime': '2026-03-13T08:00:00Z',
      'pausedTime': 900, // 15 minutes paused
      'isBillable': true,
      'createdAt': '2026-03-10T10:00:00Z',
      'updatedAt': '2026-03-13T13:30:00Z',
    },
    {
      'taskId': 'TASK-002',
      'title': 'API integration for authentication',
      'description': 'Integrate OAuth providers (Microsoft, Google)',
      'projectId': 'PROJ-001',
      'projectName': 'Mobile App Redesign',
      'status': 'New',
      'priority': 'High',
      'category': 'Development',
      'estimatedHours': 12.0,
      'elapsedHours': 0.0,
      'elapsedSeconds': 0,
      'startTime': null,
      'pausedTime': 0,
      'isBillable': true,
      'createdAt': '2026-03-12T14:00:00Z',
      'updatedAt': '2026-03-12T14:00:00Z',
    },
    {
      'taskId': 'TASK-003',
      'title': 'Database schema optimization',
      'description': 'Optimize timesheet table indexes',
      'projectId': 'PROJ-002',
      'projectName': 'Backend Optimization',
      'status': 'Overdue',
      'priority': 'Medium',
      'category': 'Database',
      'estimatedHours': 4.0,
      'elapsedHours': 6.25,
      'elapsedSeconds': 22500, // 6.25 hours in seconds
      'startTime': '2026-03-10T09:00:00Z',
      'pausedTime': 0,
      'isBillable': false,
      'createdAt': '2026-03-08T11:00:00Z',
      'updatedAt': '2026-03-13T15:00:00Z',
    },
    {
      'taskId': 'TASK-004',
      'title': 'Code review for PR #456',
      'description': 'Review pull request changes and provide feedback',
      'projectId': 'PROJ-001',
      'projectName': 'Mobile App Redesign',
      'status': 'Completed',
      'priority': 'Low',
      'category': 'Review',
      'estimatedHours': 2.0,
      'elapsedHours': 1.5,
      'elapsedSeconds': 5400, // 1.5 hours in seconds
      'startTime': '2026-03-12T16:00:00Z',
      'pausedTime': 0,
      'isBillable': true,
      'completedAt': '2026-03-12T17:30:00Z',
      'createdAt': '2026-03-12T15:00:00Z',
      'updatedAt': '2026-03-12T17:30:00Z',
    },
    {
      'taskId': 'TASK-005',
      'title': 'Write unit tests for auth module',
      'description': 'Achieve 90% code coverage for authentication',
      'projectId': 'PROJ-001',
      'projectName': 'Mobile App Redesign',
      'status': 'In Progress',
      'priority': 'Medium',
      'category': 'Testing',
      'estimatedHours': 6.0,
      'elapsedHours': 3.25,
      'elapsedSeconds': 11700, // 3.25 hours in seconds
      'startTime': '2026-03-13T10:30:00Z',
      'pausedTime': 300, // 5 minutes paused
      'isBillable': true,
      'createdAt': '2026-03-11T09:00:00Z',
      'updatedAt': '2026-03-13T14:00:00Z',
    },
  ];

  /// Mock response for create task
  static Map<String, dynamic> mockCreateTaskResponse({required String title}) {
    return {
      'success': true,
      'message': 'Task created successfully',
      'data': {
        'taskId': 'TASK-${DateTime.now().millisecondsSinceEpoch}',
        'title': title,
        'status': 'New',
        'createdAt': DateTime.now().toIso8601String(),
      }
    };
  }

  /// Mock response for get tasks
  static Map<String, dynamic> mockGetTasksResponse() {
    return {
      'success': true,
      'data': {
        'tasks': mockTasks,
        'total': mockTasks.length,
        'statuses': {
          'New': mockTasks.where((t) => t['status'] == 'New').length,
          'In Progress': mockTasks.where((t) => t['status'] == 'In Progress').length,
          'Overdue': mockTasks.where((t) => t['status'] == 'Overdue').length,
          'Completed': mockTasks.where((t) => t['status'] == 'Completed').length,
        }
      },
    };
  }

  /// Mock response for start task
  static Map<String, dynamic> mockStartTaskResponse(String taskId) {
    return {
      'success': true,
      'message': 'Task started successfully',
      'data': {
        'taskId': taskId,
        'status': 'In Progress',
        'startTime': DateTime.now().toIso8601String(),
      }
    };
  }

  /// Mock response for pause task
  static Map<String, dynamic> mockPauseTaskResponse(String taskId, int elapsedSeconds) {
    return {
      'success': true,
      'message': 'Task paused',
      'data': {
        'taskId': taskId,
        'status': 'In Progress',
        'elapsedSeconds': elapsedSeconds,
        'pausedAt': DateTime.now().toIso8601String(),
      }
    };
  }

  /// Mock response for complete task
  static Map<String, dynamic> mockCompleteTaskResponse(String taskId, int totalElapsedSeconds) {
    return {
      'success': true,
      'message': 'Task completed successfully',
      'data': {
        'taskId': taskId,
        'status': 'Completed',
        'totalElapsedSeconds': totalElapsedSeconds,
        'completedAt': DateTime.now().toIso8601String(),
      }
    };
  }
}
