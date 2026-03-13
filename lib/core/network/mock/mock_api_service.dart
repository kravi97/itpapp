/// Main mock API service for development and testing
/// This service simulates backend API responses with realistic delays
library;

import 'dart:async';
import 'package:itpapp/shared/models/task.dart';
import 'data/auth_mock_data.dart';
import 'data/task_mock_data.dart';
import 'data/project_mock_data.dart';
import 'data/timesheet_leave_mock_data.dart';
import 'data/notification_profile_mock_data.dart';

class MockApiService {
  /// Simulates network delay for realistic user experience
  static const Duration _apiDelay = Duration(milliseconds: 800);

  /// Authentication API endpoints

  /// Mock login endpoint
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(_apiDelay);

    // Validate credentials
    if (AuthMockData.validCredentials[email] == password) {
      return AuthMockData.mockAuthResponse(
        email: email,
        accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    return AuthMockData.mockInvalidCredentialsError;
  }

  /// Mock forgot password endpoint
  static Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    await Future.delayed(_apiDelay);
    return AuthMockData.mockPasswordResetResponse;
  }

  /// Mock social login endpoint
  static Future<Map<String, dynamic>> socialLogin({
    required String provider, // 'microsoft' or 'google'
    required String email,
  }) async {
    await Future.delayed(_apiDelay);
    return AuthMockData.mockSocialLoginResponse(provider: provider, email: email);
  }

  /// Task API endpoints

  /// Mock get tasks endpoint
  static Future<Map<String, dynamic>> getTasks() async {
    await Future.delayed(_apiDelay);
    return TaskMockData.mockGetTasksResponse();
  }

  /// Mock get task detail endpoint
  static Future<Map<String, dynamic>> getTaskDetail(String taskId) async {
    await Future.delayed(_apiDelay);
    try {
      final task = TaskMockData.mockTasks.firstWhere((t) => t['taskId'] == taskId);
      return {'success': true, 'data': task};
    } catch (e) {
      return {'success': false, 'message': 'Task not found', 'errorCode': 'TASK_NOT_FOUND'};
    }
  }

  /// Mock create task endpoint
  static Future<Map<String, dynamic>> createTask(Task task) async {
    await Future.delayed(_apiDelay);
    try {
      final newTaskMap = {
        'taskId': task.id,
        'title': task.title,
        'description': task.description,
        'projectId': task.projectId,
        'projectName': task.projectName,
        'status': task.status.displayName,
        'priority': task.priority.displayName,
        'category': task.category,
        'estimatedHours': task.estimatedHours,
        'elapsedSeconds': task.elapsedSeconds,
        'isBillable': task.isBillable,
        'completedAt': task.completedAt?.toIso8601String(),
        'startTime': task.startTime?.toIso8601String(),
        'createdAt': task.createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'updatedAt': task.updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      };
      TaskMockData.mockTasks.add(newTaskMap);
      return {'success': true, 'data': newTaskMap, 'message': 'Task created successfully'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create task',
        'errorCode': 'TASK_CREATION_FAILED',
      };
    }
  }

  /// Mock start task endpoint
  static Future<Map<String, dynamic>> startTask(String taskId) async {
    await Future.delayed(_apiDelay);
    return TaskMockData.mockStartTaskResponse(taskId);
  }

  /// Mock pause task endpoint
  static Future<Map<String, dynamic>> pauseTask({
    required String taskId,
    required int elapsedSeconds,
  }) async {
    await Future.delayed(_apiDelay);
    return TaskMockData.mockPauseTaskResponse(taskId, elapsedSeconds);
  }

  /// Mock complete task endpoint
  static Future<Map<String, dynamic>> completeTask({
    required String taskId,
    required int totalElapsedSeconds,
  }) async {
    await Future.delayed(_apiDelay);
    return TaskMockData.mockCompleteTaskResponse(taskId, totalElapsedSeconds);
  }

  /// Project API endpoints

  /// Mock get projects endpoint
  static Future<Map<String, dynamic>> getProjects() async {
    await Future.delayed(_apiDelay);
    return ProjectMockData.mockGetProjectsResponse();
  }

  /// Mock get project detail endpoint
  static Future<Map<String, dynamic>> getProjectDetail(String projectId) async {
    await Future.delayed(_apiDelay);
    return ProjectMockData.mockGetProjectDetailResponse(projectId);
  }

  /// Timesheet API endpoints

  /// Mock get timesheet endpoint
  static Future<Map<String, dynamic>> getTimesheet({
    required String month, // format: YYYY-MM
  }) async {
    await Future.delayed(_apiDelay);
    return TimesheetMockData.mockGetTimesheetResponse();
  }

  /// Mock submit timesheet endpoint
  static Future<Map<String, dynamic>> submitTimesheet(String timesheetId) async {
    await Future.delayed(_apiDelay);
    return TimesheetMockData.mockSubmitTimesheetResponse();
  }

  /// Leave API endpoints

  /// Mock apply leave endpoint
  static Future<Map<String, dynamic>> applyLeave({
    required String leaveType,
    required String startDate,
    required String endDate,
    String? reason,
  }) async {
    await Future.delayed(_apiDelay);
    return LeaveMockData.mockApplyLeaveResponse();
  }

  /// Mock get leave balance endpoint
  static Future<Map<String, dynamic>> getLeaveBalance() async {
    await Future.delayed(_apiDelay);
    return LeaveMockData.mockGetLeaveBalanceResponse();
  }

  /// Notification API endpoints

  /// Mock get notifications endpoint
  static Future<Map<String, dynamic>> getNotifications() async {
    await Future.delayed(_apiDelay);
    return NotificationMockData.mockGetNotificationsResponse();
  }

  /// Mock mark notification as read endpoint
  static Future<Map<String, dynamic>> markNotificationAsRead(String notificationId) async {
    await Future.delayed(_apiDelay);
    return NotificationMockData.mockMarkNotificationAsReadResponse(notificationId);
  }

  /// Profile & Settings API endpoints

  /// Mock get user profile endpoint
  static Future<Map<String, dynamic>> getUserProfile() async {
    await Future.delayed(_apiDelay);
    return ProfileSettingsMockData.mockGetProfileResponse();
  }

  /// Mock update user profile endpoint
  static Future<Map<String, dynamic>> updateUserProfile({
    String? name,
    String? phone,
    String? profilePictureUrl,
  }) async {
    await Future.delayed(_apiDelay);
    return ProfileSettingsMockData.mockUpdateProfileResponse();
  }

  /// Mock get notification preferences endpoint
  static Future<Map<String, dynamic>> getNotificationPreferences() async {
    await Future.delayed(_apiDelay);
    return ProfileSettingsMockData.mockGetNotificationPreferencesResponse();
  }

  /// Mock update notification preferences endpoint
  static Future<Map<String, dynamic>> updateNotificationPreferences({
    required Map<String, dynamic> preferences,
  }) async {
    await Future.delayed(_apiDelay);
    return ProfileSettingsMockData.mockUpdateNotificationPreferencesResponse();
  }

  /// Mock logout endpoint
  static Future<Map<String, dynamic>> logout() async {
    await Future.delayed(_apiDelay);
    return ProfileSettingsMockData.mockLogoutResponse();
  }

  // Additional endpoints for new features

  static Future<Map<String, dynamic>> getTimesheets() async {
    await Future.delayed(_apiDelay);
    return {
      'success': true,
      'data': {'timesheets': []},
    };
  }

  static Future<Map<String, dynamic>> getCurrentTimesheet() async {
    await Future.delayed(_apiDelay);
    return {
      'success': true,
      'data': {
        'timesheet': {
          'id': 'ts_1',
          'weekStartDate': DateTime.now().toIso8601String(),
          'totalHours': 32.5,
          'status': 'draft',
          'entries': [],
        },
      },
    };
  }

  static Future<Map<String, dynamic>> getTimesheetEntries(DateTime date) async {
    await Future.delayed(_apiDelay);
    return {
      'success': true,
      'data': {'entries': []},
    };
  }

  static Future<Map<String, dynamic>> getTimesheetSummary(DateTime weekStart) async {
    await Future.delayed(_apiDelay);
    return {
      'success': true,
      'data': {'totalHours': 40.0, 'byProject': {}, 'byStatus': {}},
    };
  }

  static Future<Map<String, dynamic>> addTimesheetEntry(dynamic entry) async {
    await Future.delayed(_apiDelay);
    return {'success': true, 'message': 'Timesheet entry added successfully'};
  }

  static Future<Map<String, dynamic>> getLeaveApplications() async {
    await Future.delayed(_apiDelay);
    return {
      'success': true,
      'data': {'leaveApplications': []},
    };
  }

  static Future<Map<String, dynamic>> applyForLeave(dynamic application) async {
    await Future.delayed(_apiDelay);
    return {'success': true, 'message': 'Leave application submitted successfully'};
  }

  static Future<Map<String, dynamic>> cancelLeave(String leaveId) async {
    await Future.delayed(_apiDelay);
    return {'success': true, 'message': 'Leave cancelled successfully'};
  }

  static Future<Map<String, dynamic>> getProjectStats(String projectId) async {
    await Future.delayed(_apiDelay);
    return {
      'success': true,
      'data': {
        'completedTasks': 15,
        'totalTasks': 25,
        'progress': 60,
        'budget': 100000.0,
        'spent': 60000.0,
      },
    };
  }

  static Future<Map<String, dynamic>> updateProject(dynamic project) async {
    await Future.delayed(_apiDelay);
    return {'success': true, 'message': 'Project updated successfully'};
  }

  static Future<Map<String, dynamic>> updateProfile(dynamic profile) async {
    await Future.delayed(_apiDelay);
    return {'success': true, 'message': 'Profile updated successfully'};
  }

  static Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    await Future.delayed(_apiDelay);
    return {'success': true, 'message': 'Password changed successfully'};
  }
}
