# Mock API Setup for ITP Flutter App Development

## Overview

This mock API infrastructure enables rapid development and testing of the InTimePro Flutter app without requiring a backend service. The mock APIs simulate realistic network delays and provide comprehensive test data for all major app features.

## Structure

```
lib/
└── core/
    └── network/
        └── mock/
            ├── mock_api_service.dart          (Main API service)
            └── data/
                ├── auth_mock_data.dart        (Authentication data)
                ├── task_mock_data.dart         (Task management data)
                ├── project_mock_data.dart      (Project data)
                ├── timesheet_leave_mock_data.dart  (Timesheet & leave data)
                └── notification_profile_mock_data.dart (Notifications & settings)
```

## Usage

### Basic Usage in Services/Providers

```dart
import 'package:itpapp/core/network/mock/mock_api_service.dart';

// Example: Login with mock API
final response = await MockApiService.login(
  email: 'john.doe@company.com',
  password: 'password123',
);

if (response['success']) {
  final user = response['data']['user'];
  print('Logged in as: ${user['name']}');
}
```

### Available Mock Credentials

- **Email**: `john.doe@company.com` | **Password**: `password123`
- **Email**: `jane.smith@company.com` | **Password**: `securePassword456`
- **Email**: `test@example.com` | **Password**: `test123`

## Mock API Endpoints

### Authentication
- `login(email, password)` - Authenticate user
- `forgotPassword(email)` - Request password reset
- `socialLogin(provider, email)` - OAuth login (microsoft/google)

### Tasks
- `getTasks()` - Get all tasks with status counts
- `getTaskDetail(taskId)` - Get single task details
- `createTask(...)` - Create new task
- `startTask(taskId)` - Start timer on task
- `pauseTask(taskId, elapsedSeconds)` - Pause task timer
- `completeTask(taskId, totalElapsedSeconds)` - Complete task

### Projects
- `getProjects()` - Get all assigned projects
- `getProjectDetail(projectId)` - Get single project details

### Timesheet
- `getTimesheet(month)` - Get monthly timesheet
- `submitTimesheet(date, hours, projectId)` - Submit daily timesheet

### Leave Management
- `applyLeave(leaveType, startDate, endDate)` - Apply for leave
- `getLeaveBalance()` - Get leave balance and applications

### Notifications
- `getNotifications()` - Get notification list
- `markNotificationAsRead(notificationId)` - Mark as read

### Profile & Settings
- `getUserProfile()` - Get user profile
- `updateUserProfile(name, phone, profilePictureUrl)` - Update profile
- `getNotificationPreferences()` - Get notification settings
- `updateNotificationPreferences(preferences)` - Update notification settings
- `logout()` - Logout user

## Mock Data

### Test Tasks (5 samples)
- **TASK-001**: Design system UI - In Progress (5.5/8h)
- **TASK-002**: API integration - New (0/12h)
- **TASK-003**: Database optimization - Overdue (6.25/4h)
- **TASK-004**: Code review - Completed (1.5/2h)
- **TASK-005**: Unit tests - In Progress (3.25/6h)

### Test Projects (3 samples)
- **PROJ-001**: Mobile App Redesign - 35% complete, 5 team members
- **PROJ-002**: Backend Optimization - 65% complete, 2 team members
- **PROJ-003**: Security Audit - 20% complete, 2 team members

### Test Leave Types
- Vacation (15 available)
- Casual (8 available)
- Sick (5 available)
- Parental (30 available)

## Simulated Network Delay

All mock API calls include an 800ms delay to simulate realistic network latency. This can be adjusted by modifying `_apiDelay` constant in `mock_api_service.dart`.

## Switching to Real API

To integrate real backend API:

1. Create real API service in `lib/core/network/api/`
2. Implement same method signatures as `MockApiService`
3. Replace mock imports with real API service in providers/services
4. Maintain same response format for compatibility with UI layer

## Testing Tips

### Test Account
Use the mock credentials during development. No real authentication occurs.

### Timer Testing
Mock tasks include various elapsed times to test:
- Real-time timer updates
- Overdue status detection
- Completion time tracking

### Data Persistence
Mock data is regenerated on app restart. For testing persistence:
- Implement local storage in data layer
- Add mock database (sqflite or hive)

### Performance Testing
Increase concurrent users by modifying mock data lists and monitoring app performance with 50-100 mock tasks.

## Notes

- Mock APIs return realistic response formats matching backend contracts
- All timestamps use ISO 8601 format
- Errors can be tested by using invalid IDs (will trigger 'not found' errors)
- Mock data is read-only; changes in UI don't persist across app restarts
