/// Mock notification data for development and testing
class NotificationMockData {
  /// Mock notifications list
  static List<Map<String, dynamic>> mockNotifications = [
    {
      'notificationId': 'NOT-001',
      'type': 'task_started',
      'title': 'Task Started',
      'message': 'You started task: Design system UI components',
      'taskId': 'TASK-001',
      'taskName': 'Design system UI components',
      'timestamp': DateTime.now().subtract(Duration(minutes: 30)).toIso8601String(),
      'isRead': false,
      'relatedScreen': 'task_detail',
      'relatedEntityId': 'TASK-001',
    },
    {
      'notificationId': 'NOT-002',
      'type': 'task_paused',
      'title': 'Task Paused',
      'message': 'Task paused after 2 hours 30 minutes.',
      'taskId': 'TASK-005',
      'taskName': 'Write unit tests for auth module',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
      'isRead': true,
      'relatedScreen': 'task_detail',
      'relatedEntityId': 'TASK-005',
    },
    {
      'notificationId': 'NOT-003',
      'type': 'timesheet_reminder',
      'title': 'Timesheet Reminder',
      'message': 'Don\'t forget to submit your timesheet! You have 5 hours pending.',
      'timestamp': DateTime.now().subtract(Duration(hours: 4)).toIso8601String(),
      'isRead': true,
      'relatedScreen': 'timesheet',
      'relatedEntityId': 'TS-pending',
    },
    {
      'notificationId': 'NOT-004',
      'type': 'leave_approved',
      'title': 'Leave Approved',
      'message': 'Your vacation leave (Mar 20-24) has been approved.',
      'leaveId': 'LEV-001',
      'leaveType': 'Vacation',
      'timestamp': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
      'isRead': true,
      'relatedScreen': 'leave',
      'relatedEntityId': 'LEV-001',
    },
    {
      'notificationId': 'NOT-005',
      'type': 'task_completed',
      'title': 'Task Completed',
      'message': 'Task completed: Code review for PR #456 (1h 30m)',
      'taskId': 'TASK-004',
      'taskName': 'Code review for PR #456',
      'timestamp': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
      'isRead': true,
      'relatedScreen': 'task_detail',
      'relatedEntityId': 'TASK-004',
    },
  ];

  /// Mock response for get notifications
  static Map<String, dynamic> mockGetNotificationsResponse() {
    return {
      'success': true,
      'data': {
        'notifications': mockNotifications,
        'total': mockNotifications.length,
        'unreadCount': mockNotifications.where((n) => !n['isRead']).length,
      }
    };
  }

  /// Mock response for mark notification as read
  static Map<String, dynamic> mockMarkNotificationAsReadResponse(String notificationId) {
    return {
      'success': true,
      'message': 'Notification marked as read',
      'data': {
        'notificationId': notificationId,
        'isRead': true,
      }
    };
  }

  /// Mock response for send push notification
  static Map<String, dynamic> mockSendPushNotificationResponse() {
    return {
      'success': true,
      'message': 'Push notification sent successfully',
      'data': {
        'sentAt': DateTime.now().toIso8601String(),
      }
    };
  }
}

/// Mock settings and profile data for development and testing
class ProfileSettingsMockData {
  /// Mock user profile data
  static const Map<String, dynamic> mockUserProfile = {
    'userId': 'USR-001',
    'name': 'John Doe',
    'email': 'john.doe@company.com',
    'employeeId': 'EMP-12345',
    'department': 'Engineering',
    'designation': 'Senior Software Engineer',
    'phone': '+1-555-123-4567',
    'profilePictureUrl': 'https://via.placeholder.com/150',
    'createdAt': '2024-01-15T10:30:00Z',
    'lastLogin': '2026-03-13T09:00:00Z',
  };

  /// Mock notification preferences
  static const Map<String, dynamic> mockNotificationPreferences = {
    'pushNotificationsEnabled': true,
    'appNotificationsEnabled': true,
    'soundEnabled': true,
    'vibrationEnabled': true,
    'quietHoursEnabled': true,
    'quietHoursStart': '21:00',
    'quietHoursEnd': '08:00',
    'notifyOnTaskStart': true,
    'notifyOnTaskComplete': true,
    'notifyOnTimesheetReminder': true,
    'notifyOnLeaveStatus': true,
  };

  /// Mock private time settings
  static const Map<String, dynamic> mockPrivateTimeSettings = {
    'enabled': false,
    'duration': 30, // minutes
    'isActive': false,
    'remainingTime': 0,
    'pausedTaskId': null,
  };

  /// Mock response for get profile
  static Map<String, dynamic> mockGetProfileResponse() {
    return {
      'success': true,
      'data': mockUserProfile,
    };
  }

  /// Mock response for update profile
  static Map<String, dynamic> mockUpdateProfileResponse() {
    return {
      'success': true,
      'message': 'Profile updated successfully',
      'data': mockUserProfile,
    };
  }

  /// Mock response for get notification preferences
  static Map<String, dynamic> mockGetNotificationPreferencesResponse() {
    return {
      'success': true,
      'data': mockNotificationPreferences,
    };
  }

  /// Mock response for update notification preferences
  static Map<String, dynamic> mockUpdateNotificationPreferencesResponse() {
    return {
      'success': true,
      'message': 'Notification preferences updated',
      'data': mockNotificationPreferences,
    };
  }

  /// Mock response for logout
  static Map<String, dynamic> mockLogoutResponse() {
    return {
      'success': true,
      'message': 'Logged out successfully',
      'data': {
        'logoutTime': DateTime.now().toIso8601String(),
      }
    };
  }
}
