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
      'data': {
        'timesheets': [
          {
            'id': 'ts_1',
            'weekStartDate': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
            'totalHours': TimesheetMockData.mockTimesheetEntries.fold<double>(
              0,
              (sum, entry) => sum + (entry['hours'] as num? ?? 0).toDouble(),
            ),
            'status': 'draft',
            'entries': TimesheetMockData.mockTimesheetEntries,
          },
        ],
      },
    };
  }

  static Future<Map<String, dynamic>> getCurrentTimesheet() async {
    await Future.delayed(_apiDelay);
    return {
      'success': true,
      'data': {
        'timesheet': {
          'id': 'ts_1',
          'weekStartDate': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
          'totalHours': TimesheetMockData.mockTimesheetEntries.fold<double>(
            0,
            (sum, entry) => sum + (entry['hours'] as num? ?? 0).toDouble(),
          ),
          'status': 'draft',
          'entries': TimesheetMockData.mockTimesheetEntries,
        },
      },
    };
  }

  static Future<Map<String, dynamic>> getTimesheetEntries(DateTime date) async {
    await Future.delayed(_apiDelay);
    return {
      'success': true,
      'data': {'entries': TimesheetMockData.mockTimesheetEntries},
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

    // Add entry to mock storage
    try {
      final entryMap = {
        'entryId': entry.id ?? 'TS-${DateTime.now().millisecondsSinceEpoch}',
        'date': entry.date?.toString() ?? DateTime.now().toString(),
        'hours': entry.hoursWorked ?? 0.0,
        'projectId': entry.projectId ?? 'PROJ-DEFAULT',
        'projectName': entry.projectName ?? 'General',
        'taskId': entry.taskId ?? 'TASK-DEFAULT',
        'taskName': entry.taskName ?? 'Work Entry',
        'notes': entry.notes ?? '',
        'status': 'Draft',
      };
      TimesheetMockData.mockTimesheetEntries.insert(0, entryMap);
    } catch (e) {
      // Fallback for Map type
      if (entry is Map) {
        TimesheetMockData.mockTimesheetEntries.insert(0, {
          'entryId': entry['id'] ?? 'TS-${DateTime.now().millisecondsSinceEpoch}',
          'date': entry['date']?.toString() ?? DateTime.now().toString(),
          'hours': entry['hoursWorked'] ?? 0.0,
          'projectId': entry['projectId'] ?? 'PROJ-DEFAULT',
          'projectName': entry['projectName'] ?? 'General',
          'taskId': entry['taskId'] ?? 'TASK-DEFAULT',
          'taskName': entry['taskName'] ?? 'Work Entry',
          'notes': entry['notes'] ?? '',
          'status': 'Draft',
        });
      }
    }

    return {'success': true, 'message': 'Timesheet entry added successfully'};
  }

  static Future<Map<String, dynamic>> getLeaveApplications() async {
    await Future.delayed(_apiDelay);
    return {
      'success': true,
      'data': {'leaveApplications': LeaveMockData.mockLeaveApplications},
    };
  }

  static Future<Map<String, dynamic>> applyForLeave(dynamic application) async {
    await Future.delayed(_apiDelay);

    // Add application to mock storage
    try {
      final leaveTypeString = application.leaveType?.toString() ?? 'annual';
      final appMap = {
        'id': application.id ?? 'LEAVE-${DateTime.now().millisecondsSinceEpoch}',
        'employeeId': application.employeeId ?? 'EMP-001',
        'employeeName': application.employeeName ?? 'Current User',
        'leaveType': leaveTypeString,
        'fromDate': application.fromDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'toDate': application.toDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'numberOfDays': application.numberOfDays ?? 1,
        'reason': application.reason ?? '',
        'status': 'Pending',
        'createdAt': DateTime.now().toIso8601String(),
      };
      LeaveMockData.mockLeaveApplications.insert(0, appMap);
    } catch (e) {
      // Fallback for Map type
      if (application is Map) {
        final days = application['numberOfDays'] ?? 1;
        LeaveMockData.mockLeaveApplications.insert(0, {
          'id': application['id'] ?? 'LEAVE-${DateTime.now().millisecondsSinceEpoch}',
          'employeeId': application['employeeId'] ?? 'EMP-001',
          'employeeName': application['employeeName'] ?? 'Current User',
          'leaveType': application['leaveType']?.toString() ?? 'annual',
          'fromDate': application['fromDate']?.toString() ?? DateTime.now().toString(),
          'toDate': application['toDate']?.toString() ?? DateTime.now().toString(),
          'numberOfDays': days,
          'reason': application['reason'] ?? '',
          'status': 'Pending',
          'createdAt': DateTime.now().toIso8601String(),
        });
      }
    }

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
