/// Storage keys constant definitions
class StorageKeys {
  // Auth
  static const String accessToken = 'auth_access_token';
  static const String refreshToken = 'auth_refresh_token';
  static const String userEmail = 'auth_user_email';
  static const String rememberMe = 'auth_remember_me';
  static const String sessionExpiry = 'auth_session_expiry';

  // User Profile
  static const String userProfile = 'user_profile';
  static const String userId = 'user_id';

  // Tasks
  static const String cachedTasks = 'cached_tasks';
  static const String activeTaskId = 'active_task_id';
  static const String timerState = 'timer_state';

  // Timer
  static const String timerStartTime = 'timer_start_time';
  static const String timerElapsedSeconds = 'timer_elapsed_seconds';

  // Preferences
  static const String notificationPreferences = 'notification_preferences';
  static const String appTheme = 'app_theme';

  // Offline Queue
  static const String offlineQueue = 'offline_queue';
  static const String lastSyncTime = 'last_sync_time';
}
