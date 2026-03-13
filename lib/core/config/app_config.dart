/// App configuration constants and settings
class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'https://api.itpapp.local';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int apiRetryCount = 3;

  // Feature Flags
  static const bool enableMockApi = true;
  static const bool enableOfflineMode = true;
  static const bool enableDebugLogging = true;

  // Timer Configuration
  static const Duration timerUpdateInterval = Duration(seconds: 1);
  static const Duration timerSyncInterval = Duration(minutes: 5);

  // Storage Configuration
  static const String secureStorageService = 'itp_secure_storage';
  static const String localStoragePrefix = 'itp_';

  // Authentication Configuration
  static const Duration sessionTimeout = Duration(minutes: 30);
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);
  static const String googleClientId = 'your-google-client-id.apps.googleusercontent.com';
  static const String microsoftClientId = 'your-microsoft-client-id';

  // Notification Configuration
  static const String fcmProjectId = 'your-fcm-project-id';
  static const Duration notificationPollInterval = Duration(minutes: 1);

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);

  // Sync Configuration
  static const Duration offlineQueueRetryDelay = Duration(seconds: 30);
  static const int maxOfflineQueueSize = 100;
}
