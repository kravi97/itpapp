/// Route names constants
class RouteNames {
  // Auth routes
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Tab routes
  static const String dashboard = '/dashboard';
  static const String tasks = '/tasks';
  static const String timesheet = '/timesheet';
  static const String projects = '/projects';
  static const String leave = '/leave';
  static const String settings = '/settings';

  // Detail routes
  static const String taskDetail = '/task/:taskId';
  static const String projectDetail = '/project/:projectId';

  // Settings sub-routes
  static const String profile = '/settings/profile';
  static const String notifications = '/settings/notifications';
  static const String privateTime = '/settings/private-time';
}
