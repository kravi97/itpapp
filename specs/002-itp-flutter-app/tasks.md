# Implementation Tasks: InTimePro Flutter Mobile App

**Feature Branch**: `002-itp-flutter-app`  
**Created**: March 13, 2026  
**Status**: Implementation Ready  
**Task Version**: 1.0.0  

---

## Overview

This document contains a comprehensive, dependency-ordered task list for implementing the InTimePro Flutter Mobile App. Tasks are organized into 5 phases:

- **Phase 0**: Foundational Setup (Project initialization, architecture setup, dependencies)
- **Phase 1**: Auth & Dashboard (Authentication, real-time dashboard, timer infrastructure)
- **Phase 2**: Tasks & Timesheet (Task management, timer persistence, timesheet logging)
- **Phase 3**: Projects & Leave (Project visibility, leave management)
- **Phase 4**: Notifications & Settings (Notification delivery, profile & settings management)
- **Phase 5**: Polish & Integration (Integration testing, cross-cutting concerns, refinement)

---

## Phase 0: Foundational Setup

### Core Infrastructure & Project Initialization

- [ ] T001 Create core layer directory structure and config files
  - **Requirement IDs**: Core infrastructure
  - **Description**: Set up the following in `lib/core/`:
    - `config/app_config.dart` (API endpoints, timeouts, feature flags)
    - `logging/logger.dart` (structured logging setup)
    - `storage/secure_storage_service.dart` (flutter_secure_storage wrapper)
    - `storage/local_storage_service.dart` (SharedPreferences wrapper)
    - `storage/storage_keys.dart` (constant key definitions)
    - `theme/app_theme.dart` (Material Design 3 colors, typography)
    - `navigation/route_names.dart` (named routes for all screens)
  - **Acceptance Criteria**:
    - All config files created with valid Dart syntax
    - Logger initialized and tested locally
    - Storage services wrap platform APIs correctly
    - Theme provides consistent color/typography across app
  - **Estimated Days**: 1

- [ ] T002 Set up Provider state management and dependency injection framework
  - **Requirement IDs**: Core architecture
  - **Depends on**: T001
  - **Description**: Create the global state management foundation using Provider/Riverpod:
    - `lib/core/providers/app_level_providers.dart` (global providers: AuthUserProvider, ActiveTaskProvider, TimerProvider, ConnectivityProvider, SyncQueueProvider)
    - `lib/core/providers/provider_logger.dart` (logging helper for provider state changes)
    - Implement `AppStateContainer` that initializes all global providers on app startup
    - Configure app-wide dependencies (services, API client)
  - **Acceptance Criteria**:
    - All 5 global providers defined and properly typed
    - Provider dependencies correctly declared
    - AppStateContainer initializes without errors on app launch
    - State changes logged and traceableto console
  - **Estimated Days**: 1

- [ ] T003 Implement base models and type definitions
  - **Requirement IDs**: Core data structures
  - **Depends on**: T001
  - **Description**: Create fundamental data models in `lib/shared/models/` and module-specific model files:
    - `lib/shared/models/base_entity.dart` (BaseEntity with id, createdAt, updatedAt)
    - `lib/shared/models/pagination.dart` (PaginationMeta, ListResponse)
    - `lib/shared/models/error_response.dart` (ApiError with code and message)
    - Module-level models: User, Task, Project, Timesheet, Leave, Notification
    - Enums: TaskStatus, Priority, LeaveType, NotificationType, etc.
  - **Acceptance Criteria**:
    - All models implement `BaseEntity` or appropriate base class
    - Models have `fromJson()` and `toJson()` for API serialization
    - Enums properly defined with string mapping
    - Models immutable (use `@immutable` annotation or freezed)
  - **Estimated Days**: 2

- [ ] T004 Set up navigation framework with go_router and bottom tab structure
  - **Requirement IDs**: FR-* (all modules)
  - **Depends on**: T001, T002
  - **Description**: Implement navigation in `lib/core/navigation/`:
    - `app_navigator.dart` (GoRouter configuration with all routes)
    - Define 6 main tabs: Dashboard, Tasks, Timesheet, Projects, Leave, Settings
    - Bottom tab navigation widget `lib/features/shared/widgets/bottom_tab_bar.dart`
    - Deep linking support for notifications (e.g., `/task/123` → Task Detail screen)
    - Auth guard that redirects unauthenticated users to login
  - **Acceptance Criteria**:
    - All 6 tab routes defined and navigable
    - Tab navigation persists state across tab switches
    - Deep links correctly navigate to target screens
    - Auth state properly gates access (logout clears navigation stack)
  - **Estimated Days**: 2

- [ ] T005 Implement app lifecycle management and initialization
  - **Requirement IDs**: Timer persistence, sync queue
  - **Depends on**: T002, T003, T004
  - **Description**: Create `lib/core/app_lifecycle/`:
    - `app_lifecycle_observer.dart` (WidgetsBindingObserver for pause/resume/detach)
    - `app_init_service.dart` (initialization sequence on app startup)
    - On app launch: restore timer state, restore queued sync actions, check session validity
    - On app pause: persist timer state, save sync queue
    - On app resume: validate session, trigger sync reconciliation if needed
    - Handle deep link routing on cold start
  - **Acceptance Criteria**:
    - Timer state correctly restored after app force-close
    - Sync queue reprocessed on app resume if offline
    - Session validation prevents stale auth tokens
    - Deep links work on cold start (app not running)
  - **Estimated Days**: 1

---

### Mock API & Testing Infrastructure

- [ ] T006 Verify and document mock API service endpoints
  - **Requirement IDs**: Core API infrastructure
  - **Depends on**: None (mock APIs already created)
  - **Description**: Verify the existing mock API service (`lib/core/network/mock/mock_api_service.dart`) includes:
    - 27 endpoints covering all modules (auth, task, project, timesheet, leave, notifications, settings)
    - Correct request/response DTOs
    - Documented endpoint behavior (success, error cases)
    - Review `MOCK_API_README.md` for completeness
  - **Acceptance Criteria**:
    - All 27 endpoints verified in code
    - Each endpoint returns correct mock data structure
    - Errors properly returned (401 for invalid auth, 400 for validation, etc.)
    - Documentation matches implementation
  - **Estimated Days**: 0.5

- [ ] T007 Create test fixtures and utilities
  - **Requirement IDs**: Testing infrastructure
  - **Depends on**: T003, T006
  - **Description**: Set up testing utilities in `test/`:
    - `fixtures/mock_data.dart` (test data generators for all models)
    - `mocks/mock_providers.dart` (ProviderContainer setup for widget tests)
    - `mocks/mock_api_client.dart` (mock HTTP client for unit tests)
    - `test_config.dart` (test configuration, golden file paths)
  - **Acceptance Criteria**:
    - Fixtures provide realistic test data for all entities
    - Mock providers properly override real providers in tests
    - Unit tests and widget tests can run independently
    - Golden files directory configured
  - **Estimated Days**: 1

---

## Phase 1: Auth & Dashboard

### Authentication Module (PR-LOGIN-1 through FR-LOGIN-5)

- [ ] T008 Implement AuthService and secure credential storage
  - **Requirement IDs**: FR-LOGIN-1, FR-LOGIN-2, FR-LOGIN-3, FR-LOGIN-4
  - **Depends on**: T001, T002, T003, T006
  - **Description**: Create `lib/features/auth/services/auth_service.dart`:
    - `login(email, password)` → validates credentials against mock API → returns User and SessionToken
    - `logout()` → clears session, cached data, secure storage
    - `validateSession()` → checks if stored session token is still valid
    - `saveCredentials(email, password)` if Remember Me enabled → use SecureStorageService
    - `loadSavedCredentials()` on app startup → return saved email (password not auto-filled for security)
    - Error handling: LoginException with user-friendly messages
  - **Acceptance Criteria**:
    - Valid credentials return User and SessionToken
    - Invalid credentials throw LoginException with clear message
    - Remember Me stores encrypted credentials and retrieves email on relaunch
    - Session validation returns false for wrong/expired tokens
    - Logout clears all stored data
  - **Estimated Days**: 2

- [ ] T009 Implement OAuth Service (Microsoft & Google) with PKCE flow
  - **Requirement IDs**: FR-LOGIN-5
  - **Depends on**: T001, T002, T003, T006
  - **Description**: Create `lib/features/auth/services/oauth_service.dart`:
    - `loginWithGoogle()` → uses google_sign_in, initiates OAuth flow, returns User + SessionToken
    - `loginWithMicrosoft()` → uses flutter_appauth, initiates OAuth flow, returns User + SessionToken
    - Token refresh: `refreshOAuthToken()` on token expiry
    - Graceful fallback if OAuth provider unavailable
    - Create/link account logic (first-time OAuth creates new user account)
  - **Acceptance Criteria**:
    - Google/Microsoft OAuth flows complete and return valid user session
    - OAuth profile data synced to User model
    - Token refresh works transparently
    - New users automatically created on first social login
  - **Estimated Days**: 2

- [ ] T010 Create AuthProvider (Riverpod/Bloc) for global user state
  - **Requirement IDs**: FR-LOGIN-1 through FR-LOGIN-5
  - **Depends on**: T002, T008, T009
  - **Description**: Create `lib/features/auth/providers/auth_provider.dart`:
    - `authUserProvider` → FutureProvider<User?> that loads session on startup
    - `authStateProvider` → notifier for login/logout state machine
    - `sessionTokenProvider` → exposes current session token for API calls
    - Auto-logout on session timeout (check every 1 minute if still valid)
    - Integration with app lifecycle (logout on app detach)
  - **Acceptance Criteria**:
    - AuthUserProvider reflects current authentication state
    - Session token available to all API calls via dependency injection
    - Auto-logout triggers after 30 minutes inactivity (configurable)
    - Logout clears all auth state including tokens
  - **Estimated Days**: 1.5

- [ ] T011 Build Login Screen UI with email/password form
  - **Requirement IDs**: FR-LOGIN-1, FR-LOGIN-2, FR-LOGIN-3
  - **Depends on**: T001, T004, T008, T010
  - **Description**: Create `lib/features/auth/screens/login_screen.dart`:
    - Email input field with validation (valid email format)
    - Password input field with show/hide toggle
    - "Remember Me" checkbox
    - Login button (disabled until both fields filled)
    - Loading indicator during authentication
    - Error message display with red text
    - Forgot password link
    - Navigate to Dashboard on success
  - **Acceptance Criteria**:
    - Form validation prevents submission with empty fields
    - Loading indicator appears during auth request
    - Error messages correct for invalid credentials
    - Remember Me preserves email on relaunch
    - Successful login navigates to Dashboard
  - **Estimated Days**: 1.5

- [ ] T012 Build OAuth buttons (Google & Microsoft sign-in)
  - **Requirement IDs**: FR-LOGIN-5
  - **Depends on**: T001, T004, T009, T010
  - **Description**: Create `lib/features/auth/widgets/oauth_buttons.dart`:
    - Google Sign-In button (Material Design style with Google branding)
    - Microsoft Sign-In button
    - Show loading state while OAuth flow in progress
    - Error handling for OAuth failures
    - Both buttons on LoginScreen below email/password form
  - **Acceptance Criteria**:
    - OAuth buttons styled per material design specs
    - Tapping button initiates OAuth flow
    - Loading state shown during authentication
    - Successful OAuth returns to dashboard
    - Error messages human-readable
  - **Estimated Days**: 1

- [ ] T013 Implement forgot-password flow (email-based reset)
  - **Requirement IDs**: FR-LOGIN-4
  - **Depends on**: T001, T004, T006, T008
  - **Description**: Create `lib/features/auth/screens/forgot_password_screen.dart`:
    - Email input field
    - Submit button that calls `authService.requestPasswordReset(email)`
    - Mock API returns success confirmation (24-hour reset link sent)
    - Success message: "Password reset link sent to [email] (valid for 24 hours)"
    - Back to login link
  - **Acceptance Criteria**:
    - Email field validates proper email format
    - Submit calls mock API correctly
    - Success message displays on valid submission
    - Error message if email not found
    - Back to login navigates correctly
  - **Estimated Days**: 1

- [ ] T014 Create authentication tests (unit & widget)
  - **Requirement IDs**: FR-LOGIN-1 through FR-LOGIN-5
  - **Depends on**: T008, T009, T010, T011, T012, T013, T007
  - **Description**: Create test files:
    - `test/features/auth/services/auth_service_test.dart` (login, logout, remember me)
    - `test/features/auth/services/oauth_service_test.dart` (google, microsoft flows)
    - `test/features/auth/screens/login_screen_test.dart` (form validation, error display)
    - Test valid/invalid credentials, OAuth success/failure, remember me persistence
  - **Acceptance Criteria**:
    - 100% coverage of AuthService methods
    - All user flows (happy path, error cases) tested
    - OAuth flows mocked and verified
    - Widget test confirms UI updates on state changes
    - All tests pass
  - **Estimated Days**: 2

---

### Dashboard & Timer Infrastructure

- [ ] T015 Implement Timer Service with device-clock-driven increments
  - **Requirement IDs**: FR-HOME-3, FR-HOME-7 (real-time timer)
  - **Depends on**: T001, T002, T003, T005
  - **Description**: Create `lib/features/dashboard/services/timer_service.dart` and `lib/core/timer/`:
    - `TimerState` model: activeTaskId, elapsedSeconds, status, lastSyncTime, serverElapsedSeconds
    - `startTimer(taskId, initialElapsed)` → begin device clock-driven increments every 100ms
    - `pauseTimer()` → freeze timer state, save to local storage
    - `resumeTimer()` → restart from saved state
    - `getTimerStream()` → emits TimerState every 100ms for Dashboard real-time updates
    - Periodic validation: every 30s, call `validateTimerWithServer()` to reconcile with mock API
    - Divergence handling: if device and server differ by >5s, adjust device timer
    - Persist timer state on app pause (lifecycle observer triggers save)
  - **Acceptance Criteria**:
    - Timer increments reliably every 100ms (±50ms tolerance)
    - Real-time stream updates Dashboard within 500ms
    - Timer persists across app pause/resume
    - Periodic validation reconciles device/server time
    - Divergence handled smoothly without user disruption
  - **Estimated Days**: 2

- [ ] T016 Create TimerProvider (Riverpod) and ConnectivityProvider for global state
  - **Requirement IDs**: FR-HOME-3 (real-time display)
  - **Depends on**: T002, T015, T005
  - **Description**: Create `lib/core/providers/timer_provider.dart` and `connectivity_provider.dart`:
    - `timerProvider` → StateNotifier<TimerState> exposed app-wide
    - `timerStreamProvider` → Stream<TimerState> for Dashboard subscription
    - `connectivityProvider` → StateNotifier<bool> (true=online, false=offline)
    - ConnectivityService monitors network state and updates provider
    - SyncQueueProvider triggered when connectivity restored
  - **Acceptance Criteria**:
    - TimerProvider updates reflect device clock increments
    - Dashboard receives timer updates within 500ms
    - Connectivity state changes trigger sync queue processing
    - Timer state persists across provider rebuilds
  - **Estimated Days**: 1

- [ ] T017 Implement DashboardService for fetching summary data
  - **Requirement IDs**: FR-HOME-1, FR-HOME-4, FR-HOME-5
  - **Depends on**: T001, T006
  - **Description**: Create `lib/features/dashboard/services/dashboard_service.dart`:
    - `fetchDashboardSummary(userId)` → calls mock API, returns DashboardSummary:
      - clockInTime (HH:MM format)
      - statusIndicator (online/offline)
      - totalTimeAtWork (HH:MM:SS including breaks)
      - activeTaskDetails (name, ID, elapsed, billable, category)
    - `subscribeToSummary(userId)` → returns Stream for real-time updates
    - Cache summary for 5 seconds to reduce API calls
  - **Acceptance Criteria**:
    - Mock API returns complete summary data
    - Time formatting correct (HH:MM for clock, HH:MM:SS for totals)
    - Summary updates available via stream
    - Caching reduces unnecessary API calls
  - **Estimated Days**: 1

- [ ] T018 Build Dashboard Screen UI with real-time timer display
  - **Requirement IDs**: FR-HOME-1 through FR-HOME-8
  - **Depends on**: T001, T004, T015, T016, T017
  - **Description**: Create `lib/features/dashboard/screens/dashboard_screen.dart` and widgets:
    - Clock-in time card: displays HH:MM + online/offline status (green/red indicator)
    - Active hours display: shows HH:MM format, updates every second in real-time
    - Total time at work card: shows HH:MM:SS
    - Active task card: name, task ID, elapsed time, billable indicator, category
    - Quick-action buttons: Start / Pause / Resume / Complete (disabled when no task selected)
    - Task status indicator: shows current status (In Progress, Paused, Overdue with warning)
    - Offline indicator: red banner if connectivity lost
    - Real-time updates without requiring screen refresh
  - **Acceptance Criteria**:
    - Timer updates visible every ~100ms
    - Status indicators render correctly
    - Offline state shown with red banner
    - Quick-action buttons enable/disable appropriately
    - No UI jank during timer updates
  - **Estimated Days**: 2

- [ ] T019 Implement online/offline status service and connectivity detection
  - **Requirement IDs**: FR-HOME-2 (status indicator)
  - **Depends on**: T001, T005
  - **Description**: Create `lib/features/dashboard/services/online_status_service.dart`:
    - Monitor device connectivity using connectivity_plus plugin
    - Provide stream of online/offline status changes
    - Update ConnectivityProvider on status change
    - Trigger sync queue processing when transitioning from offline to online
  - **Acceptance Criteria**:
    - Status correctly reflects network connectivity
    - Stream emits changes within 1 second of connectivity change
    - Offline state triggers sync queue reconciliation
  - **Estimated Days**: 1

- [ ] T020 Create Dashboard integration tests and real-time timer verification
  - **Requirement IDs**: FR-HOME-1 through FR-HOME-8
  - **Depends on**: T015, T016, T017, T018, T019, T007
  - **Description**: Create test files:
    - `test/features/dashboard/services/timer_service_test.dart` (increment, pause, sync)
    - `test/features/dashboard/screens/dashboard_screen_test.dart` (real-time updates, offline state)
    - Integration test: start task → timer increments in dashboard → verify within tolerance
    - Test offline scenario: pause app → go offline → resume → timer catches up
  - **Acceptance Criteria**:
    - Timer increments with <500ms update latency
    - Dashboard correctly displays all summary components
    - Offline indicator shown when disconnected
    - All real-time updates verified
  - **Estimated Days**: 2

---

## Phase 2: Tasks & Timesheet

### Task Management Module (FR-TASK-1 through FR-TASK-10)

- [ ] T021 Implement TaskService with CRUD and lifecycle management
  - **Requirement IDs**: FR-TASK-1, FR-TASK-2, FR-TASK-4, FR-TASK-5, FR-TASK-8
  - **Depends on**: T001, T002, T003, T006
  - **Description**: Create `lib/features/task/services/task_service.dart`:
    - `createTask(title, projectId, estimatedHours, priority, description)` → calls mock API, returns Task with "New" status
    - `listTasks(status)` → returns List<Task> filtered by status (NEW, IN_PROGRESS, OVERDUE, COMPLETED)
    - `getTask(taskId)` → returns single Task with full details
    - `startTask(taskId)` → changes status to IN_PROGRESS, auto-pauses any active task, publishes task_start event
    - `pauseTask(taskId, elapsedSeconds)` → freezes timer without completing task, status remains IN_PROGRESS with paused state
    - `completeTask(taskId, elapsedSeconds, timestamp)` → changes status to COMPLETED, stops timer, records timestamp
    - `calculateTaskStatus()` → transitions IN_PROGRESS task to OVERDUE if elapsed > estimated
    - Error handling: TaskException for invalid state transitions
  - **Acceptance Criteria**:
    - All CRUD operations call mock API with correct payloads
    - Task status transitions follow state machine rules
    - Single active task constraint enforced (auto-pause previous)
    - Task detail includes all required fields
    - Errors return meaningful messages
  - **Estimated Days**: 2

- [ ] T022 Implement ActiveTaskProvider and task state management
  - **Requirement IDs**: FR-TASK-5 (single active task)
  - **Depends on**: T002, T021
  - **Description**: Create `lib/features/task/providers/active_task_provider.dart`:
    - `activeTaskProvider` → StateNotifier<Task?> tracking currently running task
    - Expose at app-level in core providers for Dashboard and Notifications consumption
    - Track active task state changes: subscribe to TaskService events
    - Validate single-active constraint (throw exception if violated)
    - Auto-pause logic integrated (triggering pause on previous when new task starts)
  - **Acceptance Criteria**:
    - Only one task can be active at a time
    - ActiveTaskProvider state accurate and updated in real-time
    - Dashboard and Notifications can consume provider
    - State persists across module navigation
  - **Estimated Days**: 1

- [ ] T023 Implement TaskListProvider and task filtering by status
  - **Requirement IDs**: FR-TASK-3 (task tabs with badge counts)
  - **Depends on**: T002, T021
  - **Description**: Create `lib/features/task/providers/task_list_provider.dart`:
    - `taskListProvider` → StateNotifier<List<Task>> all tasks for authenticated user
    - `tasksByStatusProvider` → computed providers filtering tasks by status: NEW, IN_PROGRESS, OVERDUE, COMPLETED
    - `statusBadgeCountProvider` → provides badge counts for each tab
    - Auto-refresh on task creation, status change, completion
    - Support sorting within each status (by created date, estimated hours)
  - **Acceptance Criteria**:
    - All tasks listed and correctly filtered by status
    - Badge counts accurate and update in real-time
    - Sorting options work when toggled
  - **Estimated Days**: 1

- [ ] T024 Build Task List Screen with tabbed status view
  - **Requirement IDs**: FR-TASK-1, FR-TASK-2, FR-TASK-3, FR-TASK-9, FR-TASK-10
  - **Depends on**: T001, T004, T021, T022, T023
  - **Description**: Create `lib/features/task/screens/task_list_screen.dart` and widgets:
    - Top navigation bar with "+ Create Task" button
    - 4 tabs: New, In Progress, Overdue, Completed (with badge counts)
    - Task list view within each tab:
      - Task card showing: name, ID, elapsed time, estimated hours, priority, category, status indicator
      - Overdue tasks show red warning with overtime amount
      - Tap task card to open detail screen
    - Empty state message when no tasks in tab
    - Pull-to-refresh to reload task list
    - Sorting toggle (created date / estimated hours)
  - **Acceptance Criteria**:
    - All 4 tabs render with correct tasks
    - Badge counts reflect task count in each status
    - Task card layout matches spec (displays all required fields)
    - Overdue tasks show red warning
    - Pull-to-refresh reloads list
    - Sorting works within each tab
  - **Estimated Days**: 2

- [ ] T025 Build Create Task Screen with form validation
  - **Requirement IDs**: FR-TASK-1, FR-TASK-2
  - **Depends on**: T001, T004, T021
  - **Description**: Create `lib/features/task/screens/create_task_screen.dart` and form widgets:
    - Title input (max 255 characters, required)
    - Project dropdown (required) → fetches from ProjectService
    - Estimated hours input (decimal, required, e.g., 2.5 hours)
    - Priority dropdown: Low, Medium, High (required)
    - Description textarea (optional, max 1000 characters)
    - Create button (enabled only when required fields filled)
    - Cancel button
    - Show loading indicator during submission
    - On success: navigate to Task List screen with success toast
    - On error: show error message below relevant field
  - **Acceptance Criteria**:
    - Form validation enforces required fields
    - Description character limit enforced
    - Project list populated from mock API
    - Create button disabled until form valid
    - Success navigation to Task List with newly created task visible
    - Error handling displays per-field messages
  - **Estimated Days**: 1.5

- [ ] T026 Build Task Detail Screen with action buttons
  - **Requirement IDs**: FR-TASK-4, FR-TASK-5, FR-TASK-6, FR-TASK-7, FR-TASK-8, FR-TASK-10
  - **Depends on**: T001, T004, T021, T022, T015
  - **Description**: Create `lib/features/task/screens/task_detail_screen.dart`:
    - Task header: name, ID, status badge, priority indicator
    - Elapsed time display (from timer provider, real-time updates)
    - Estimated hours display
    - Project link (clickable to navigate to project detail)
    - Category/tags
    - Action buttons based on status:
      - NEW status: Start button
      - IN_PROGRESS status: Pause, Resume, Complete buttons
      - Pause/Resume button text toggles based on timer state
      - Complete button shows confirmation dialog before proceeding
    - Overdue indicator with red background and overtime amount if applicable
    - Back button to return to task list
  - **Acceptance Criteria**:
    - Action buttons render correctly per status
    - Timer display updates in real-time (every 100ms)
    - Completion confirmation dialog prevents accidental task completion
    - Overdue indicator visible when elapsed > estimated
    - Back navigation returns to task list
  - **Estimated Days**: 1.5

- [ ] T027 Implement task completion confirmation dialog
  - **Requirement IDs**: FR-TASK-8, FR-HOME-7
  - **Depends on**: T001, T021, T026
  - **Description**: Create `lib/features/task/widgets/task_completion_dialog.dart`:
    - Modal dialog: "Complete this task?" message
    - Show task name and elapsed time
    - Two buttons: "Cancel", "Confirm"
    - On Cancel: dismiss dialog, task remains active
    - On Confirm: call TaskService.completeTask() with current elapsed time and timestamp
    - Show loading indicator while completing
    - On success: close dialog, return to Task List with success toast
    - On error: show error message in dialog
  - **Acceptance Criteria**:
    - Dialog displays correctly when Complete button tapped
    - Cancel button dismisses without action
    - Confirm button calls TaskService.completeTask()
    - Task status updates to COMPLETED after confirmation
  - **Estimated Days**: 1

- [ ] T028 Create task management tests (unit & widget)
  - **Requirement IDs**: FR-TASK-1 through FR-TASK-10
  - **Depends on**: T021, T022, T023, T024, T025, T026, T027, T007
  - **Description**: Create test files:
    - `test/features/task/services/task_service_test.dart` (create, list, status transitions, overdue detection)
    - `test/features/task/screens/task_list_screen_test.dart` (tab routing, badge counts, sorting)
    - `test/features/task/screens/create_task_screen_test.dart` (form validation, submit)
    - `test/features/task/screens/task_detail_screen_test.dart` (action buttons, timer integration)
    - Integration tests: create task → appears in NEW tab → start task → moves to IN_PROGRESS → complete task → moves to COMPLETED
  - **Acceptance Criteria**:
    - All task operations verified with correct state transitions
    - UI tests confirm form validation and user flows
    - Overdue detection triggers at correct time
    - Single active task constraint enforced
    - All tests pass with >80% code coverage
  - **Estimated Days**: 2

---

### Timesheet Module (FR-TIME-1 through FR-TIME-8)

- [ ] T029 Implement TimesheetService with hour logging and submission
  - **Requirement IDs**: FR-TIME-1, FR-TIME-2, FR-TIME-3, FR-TIME-4, FR-TIME-5, FR-TIME-6, FR-TIME-7, FR-TIME-8
  - **Depends on**: T001, T003, T006
  - **Description**: Create `lib/features/timesheet/services/timesheet_service.dart`:
    - `logHours(date, startTime, endTime, projectId, notes)` → creates/updates LogEntry for that date, calls mock API
    - `getCalendarView(year, month)` → returns List<TimesheetDay> with hours logged per date
    - `submitTimesheet(date)` → submits timesheet for a date, locks it as read-only, records timestamp
    - `getSubmissionHistory()` → returns List<TimesheetSubmission> with status and approval info
    - `calculateTotals()` → returns TimesheetTotals (logged hours, submitted hours, difference, weekly/monthly)
    - Error handling: TimesheetException for invalid submissions, read-only violations
  - **Acceptance Criteria**:
    - Hour logging persists and updates calendar view
    - Submit locks timesheet and records timestamp
    - History shows all past submissions with approval status
    - Totals calculated correctly (logged vs submitted)
    - Cannot edit submitted/approved timesheets
  - **Estimated Days**: 2

- [ ] T030 Create TimesheetProviders for calendar and submission state
  - **Requirement IDs**: FR-TIME-1 through FR-TIME-8
  - **Depends on**: T002, T029
  - **Description**: Create `lib/features/timesheet/providers/`:
    - `calendarMonthProvider` → StateNotifier<TimesheetMonth> (current month view, dates, hours)
    - `submissionHistoryProvider` → FutureProvider<List<TimesheetSubmission>>
    - `timesheetTotalsProvider` → FutureProvider<TimesheetTotals> (logged, submitted, weekly, monthly)
    - Auto-refresh on hour logging or submission
  - **Acceptance Criteria**:
    - Calendar display reflects logged hours in real-time
    - History and totals update after submission
    - Month navigation updates provider state
  - **Estimated Days**: 1

- [ ] T031 Build Timesheet Screen with monthly calendar view
  - **Requirement IDs**: FR-TIME-1, FR-TIME-3
  - **Depends on**: T001, T004, T029, T030
  - **Description**: Create `lib/features/timesheet/screens/timesheet_screen.dart` and calendar widget:
    - Calendar displaying current month (grid format: Sun-Sat columns)
    - Each date cell shows hours logged (e.g., "8.0 hrs")
    - Current day highlighted with special styling
    - Month navigation arrows (previous/next month)
    - Month/year header
    - Tap date cell to open day entry editor
    - Empty state for dates with no hours logged
    - Total hours logged this month displayed at bottom
  - **Acceptance Criteria**:
    - Calendar displays correct current month
    - Dates with logged hours show amounts
    - Month navigation works correctly
    - Current day highlighted
    - Tap date opens day entry screen
  - **Estimated Days**: 2

- [ ] T032 Build Day Entry Screen for logging hours
  - **Requirement IDs**: FR-TIME-2, FR-TIME-3
  - **Depends on**: T001, T004, T029
  - **Description**: Create `lib/features/timesheet/screens/day_entry_screen.dart`:
    - Date header showing selected date
    - Time range picker: start time and end time (HH:MM format with spinner)
    - Hours display (calculated from start/end times, read-only)
    - Project dropdown (required) → fetches from ProjectService
    - Notes textarea (optional)
    - Save and Cancel buttons
    - On Save: call TimesheetService.logHours(), return to calendar
    - On error: show error message
    - If timesheet submitted for that date: show read-only state, no edit option
  - **Acceptance Criteria**:
    - Time picker functional and correctly calculates hours
    - Project dropdown populated correctly
    - Save creates/updates log entry
    - Submitted timesheets show read-only state
    - Back navigation returns to calendar
  - **Estimated Days**: 1.5

- [ ] T033 Build Timesheet Submission Screen with confirmation
  - **Requirement IDs**: FR-TIME-4, FR-TIME-5, FR-TIME-7
  - **Depends on**: T001, T004, T029, T031
  - **Description**: Create `lib/features/timesheet/screens/timesheet_submission_dialog.dart`:
    - Modal dialog showing summary of daily hours to submit
    - Total hours for the submission period
    - Submit button with confirmation
    - Show submission timestamp after success
    - Prevent resubmission of same timesheet period (show locked state)
  - **Acceptance Criteria**:
    - Dialog shows correct total hours
    - Submit button calls TimesheetService.submitTimesheet()
    - Submission locks timesheet as read-only
    - Timestamp recorded and displayed
    - Cannot resubmit same timesheet
  - **Estimated Days**: 1

- [ ] T034 Build Submission History Screen
  - **Requirement IDs**: FR-TIME-6
  - **Depends on**: T001, T004, T029
  - **Description**: Create `lib/features/timesheet/screens/submission_history_screen.dart`:
    - List of submitted timesheets
    - Each item shows: date range, total hours, submission timestamp, approval status (PENDING/APPROVED/REJECTED with color badges)
    - Tap item to see details (read-only view of logged hours for that submission)
    - Empty state if no submissions
  - **Acceptance Criteria**:
    - All submissions listed with correct status
    - Status badges colored correctly (orange/green/red)
    - Tap item shows submission details
  - **Estimated Days**: 1

- [ ] T035 Build Timesheet Totals Screen with summary breakdowns
  - **Requirement IDs**: FR-TIME-7, FR-TIME-8
  - **Depends on**: T001, T004, T029
  - **Description**: Create `lib/features/timesheet/screens/timesheet_totals_screen.dart`:
    - Total logged hours (HH:MM format, sum of all logged entries)
    - Total submitted hours (HH:MM format, sum of all submitted timesheets)
    - Difference between logged and submitted (HH:MM format)
    - Weekly breakdown (7 rows, one per week of current month, showing hours per week)
    - Monthly total breakdown (total hours this month)
    - Charts or simple tables for visual breakdown
  - **Acceptance Criteria**:
    - All totals calculated correctly
    - Weekly and monthly breakdowns accurate
    - Update real-time as hours logged
  - **Estimated Days**: 1.5

- [ ] T036 Create timesheet tests (unit & widget)
  - **Requirement IDs**: FR-TIME-1 through FR-TIME-8
  - **Depends on**: T029, T030, T031, T032, T033, T034, T035, T007
  - **Description**: Create test files:
    - `test/features/timesheet/services/timesheet_service_test.dart` (log, submit, calculate totals)
    - `test/features/timesheet/screens/timesheet_screen_test.dart` (calendar display, month nav)
    - `test/features/timesheet/screens/day_entry_screen_test.dart` (time picker, hour calculation)
    - Integration tests: log hours for multiple dates → calendar updates → submit → verify locked state
  - **Acceptance Criteria**:
    - Hour logging verified
    - Submit locks timesheet
    - Totals calculated correctly
    - Read-only enforcement on submitted timesheets
    - All tests pass with >80% coverage
  - **Estimated Days**: 2

---

## Phase 3: Projects & Leave

### Project Management Module (FR-PROJ-1 through FR-PROJ-6)

- [ ] T037 Implement ProjectService with project and progress tracking
  - **Requirement IDs**: FR-PROJ-1, FR-PROJ-2, FR-PROJ-3, FR-PROJ-4, FR-PROJ-5, FR-PROJ-6
  - **Depends on**: T001, T003, T006
  - **Description**: Create `lib/features/project/services/project_service.dart`:
    - `listProjects(userId)` → returns List<Project> for authenticated user
    - `getProjectDetail(projectId)` → returns Project with full info (description, team members, task breakdown)
    - `calculateProgress(projectId)` → returns progress percentage (completed tasks / total tasks)
    - `calculateDaysRemaining(projectId)` → returns days until end date (negative if overdue)
    - `getTaskBreakdown(projectId)` → returns task counts by status (NEW, IN_PROGRESS, OVERDUE, COMPLETED)
    - Sorting: projects by progress percentage or by dates
  - **Acceptance Criteria**:
    - Project list includes all required fields (name, progress, dates, team count)
    - Progress calculated correctly as completed/total ratio
    - Days remaining calculated correctly
    - Task breakdown accurate (sums to total task count)
    - Sorting works correctly
  - **Estimated Days**: 1.5

- [ ] T038 Create ProjectProvider for global project state
  - **Requirement IDs**: FR-PROJ-1 through FR-PROJ-6
  - **Depends on**: T002, T037
  - **Description**: Create `lib/features/project/providers/`:
    - `projectListProvider` → FutureProvider<List<Project>>
    - `projectDetailProvider(projectId)` → FutureProvider<Project>
    - `projectProgressProvider(projectId)` → computed provider with real-time progress updates
    - Auto-refresh when task status changes (task completion updates project progress)
  - **Acceptance Criteria**:
    - Project list and detail providers work independently
    - Progress updates in real-time when tasks completed
  - **Estimated Days**: 1

- [ ] T039 Build Project List Screen with progress cards
  - **Requirement IDs**: FR-PROJ-1, FR-PROJ-2, FR-PROJ-3, FR-PROJ-4, FR-PROJ-5, FR-PROJ-6
  - **Depends on**: T001, T004, T037, T038
  - **Description**: Create `lib/features/project/screens/project_list_screen.dart` and widgets:
    - Grid or list of project cards, each showing:
      - Project name
      - Progress bar (0-100%, color-coded: green for on-track)
      - Start and end dates (MMM DD, YYYY format)
      - Days remaining badge (with red warning if overdue)
      - Team member avatars (up to 4 with "+X" indicator if more)
      - Task count breakdown (New/In Progress/Overdue/Completed)
    - Tap card to open project detail
    - Sorting toggle (by progress / by dates)
    - Empty state if no projects
  - **Acceptance Criteria**:
    - All project cards render correctly
    - Progress bars color-coded appropriately
    - Dates formatted as "MMM DD, YYYY"
    - Days remaining shows negative for overdue
    - Team avatars display with "+X" indicator
    - Tap card navigates to detail screen
  - **Estimated Days**: 2

- [ ] T040 Build Project Detail Screen with task breakdown
  - **Requirement IDs**: FR-PROJ-1, FR-PROJ-2, FR-PROJ-4, FR-PROJ-5
  - **Depends on**: T001, T004, T037, T038
  - **Description**: Create `lib/features/project/screens/project_detail_screen.dart`:
    - Project header: name, progress bar, dates, status
    - Description section
    - Team members section:
      - List of members with avatars, names, designations
      - Expandable from card view
    - Task breakdown section:
      - Pie chart or table showing task counts by status
      - New/In Progress/Overdue/Completed
    - Back button to project list
  - **Acceptance Criteria**:
    - All project details display correctly
    - Team member list complete with avatars
    - Task breakdown chart/table shows accurate counts
    - Back navigation works
  - **Estimated Days**: 1.5

- [ ] T041 Create project UI components (progress bar, avatars, status badge)
  - **Requirement IDs**: FR-PROJ-1 through FR-PROJ-6
  - **Depends on**: T001
  - **Description**: Create reusable widgets in `lib/features/project/widgets/`:
    - `progress_bar.dart` → displays progress 0-100% with color coding (green for on-track, yellow, red)
    - `team_avatars.dart` → displays up to 4 member avatars with "+X" indicator, tap-to-expand
    - `days_remaining_badge.dart` → shows days remaining or "X days overdue" with red styling if negative
    - `task_breakdown_chart.dart` → pie chart or horizontal bar chart showing task status distribution
  - **Acceptance Criteria**:
    - All components render correctly with proper styling
    - Color coding appropriate for status
    - Avatars resize and stack properly
    - Badge styling correct for overdue state
  - **Estimated Days**: 1.5

- [ ] T042 Create project tests (unit & widget)
  - **Requirement IDs**: FR-PROJ-1 through FR-PROJ-6
  - **Depends on**: T037, T038, T039, T040, T041, T007
  - **Description**: Create test files:
    - `test/features/project/services/project_service_test.dart` (list, detail, progress, days remaining)
    - `test/features/project/screens/project_list_screen_test.dart` (card rendering, sorting)
    - `test/features/project/screens/project_detail_screen_test.dart` (team member display, task breakdown)
    - Integration tests: verify progress updates when task completed
  - **Acceptance Criteria**:
    - Progress calculation verified
    - Days remaining logic correct (including negative for overdue)
    - UI components render correctly with mock data
    - All tests pass with >80% coverage
  - **Estimated Days**: 2

---

### Leave Management Module (FR-LEAVE-1 through FR-LEAVE-7)

- [ ] T043 Implement LeaveService with application and balance management
  - **Requirement IDs**: FR-LEAVE-1, FR-LEAVE-2, FR-LEAVE-3, FR-LEAVE-4, FR-LEAVE-5, FR-LEAVE-6, FR-LEAVE-7
  - **Depends on**: T001, T003, T006
  - **Description**: Create `lib/features/leave/services/leave_service.dart`:
    - `applyForLeave(startDate, endDate, leaveType, notes)` → creates LeaveApplication, calls mock API
    - `getApplications()` → returns List<LeaveApplication> for authenticated user with status
    - `getApprovedLeave()` → returns List<ApprovedLeave> (booked periods)
    - `getLeaveBalance()` → returns List<LeaveBalance> per type (available, booked, annual, allocation, expiry)
    - `getLeaveEntitlements()` → returns LeaveEntitlement per type with allocation date and expiry
    - `calculateLeaveDays(startDate, endDate)` → returns number of leave days
    - `validateApplication(startDate, endDate, leaveType)` → checks for overlaps, insufficient balance, past dates
  - **Acceptance Criteria**:
    - Leave applications persisted with correct status
    - Balance calculations accurate
    - Validation prevents invalid applications (past dates, overlaps, insufficient balance)
    - Entitlement data includes allocation and expiry dates
  - **Estimated Days**: 2

- [ ] T044 Create LeaveProviders for applications and balances
  - **Requirement IDs**: FR-LEAVE-1 through FR-LEAVE-7
  - **Depends on**: T002, T043
  - **Description**: Create `lib/features/leave/providers/`:
    - `leaveApplicationListProvider` → FutureProvider<List<LeaveApplication>>
    - `leaveBalanceProvider` → FutureProvider<List<LeaveBalance>>
    - `approvedLeaveProvider` → FutureProvider<List<ApprovedLeave>>
    - `leaveEntitlementProvider` → FutureProvider<List<LeaveEntitlement>>
    - Auto-refresh on new application or status change
  - **Acceptance Criteria**:
    - Providers fetch and cache data correctly
    - Updates trigger when applications submitted or statuses changed
  - **Estimated Days**: 1

- [ ] T045 Build Leave Application Screen with form and validation
  - **Requirement IDs**: FR-LEAVE-1, FR-LEAVE-2, FR-LEAVE-3
  - **Depends on**: T001, T004, T043, T044
  - **Description**: Create `lib/features/leave/screens/leave_application_screen.dart`:
    - Date range picker:
      - Start date and end date inputs with calendar picker
      - Block past dates (cannot select dates before today)
      - Block already-booked dates (check against ApprovedLeave)
    - Leave type dropdown (Vacation, Casual, Sick, Parental):
      - Show balance for each type (e.g., "Vacation (8.5 days available)")
      - Show description for each leave type
    - Notes textarea (optional, max 500 characters)
    - Days display (auto-calculated from date range, read-only)
    - Apply and Cancel buttons
    - Form validation errors shown inline
    - On Apply: call LeaveService.applyForLeave(), navigate to leave applications list with success toast
  - **Acceptance Criteria**:
    - Date picker prevents past date selection
    - Already-booked dates appear blocked/disabled
    - Leave type dropdown shows balance
    - Days calculated correctly from date range
    - Form validation errors display properly
    - Successful application navigates to list and shows in applications with PENDING status
  - **Estimated Days**: 2

- [ ] T046 Build Leave Balance Screen with entitlement details
  - **Requirement IDs**: FR-LEAVE-5, FR-LEAVE-6
  - **Depends on**: T001, T004, T043, T044
  - **Description**: Create `lib/features/leave/screens/leave_balance_screen.dart`:
    - Card per leave type showing:
      - Type name and description
      - Available days (visual progress bar or simple number)
      - Currently booked days
      - Annual allocation (total entitlement)
      - Allocation date (when entitlement started)
      - Expiry date (when unused leave expires)
      - Carry-over balance (if applicable)
    - Summary section with total available, booked, and annual
  - **Acceptance Criteria**:
    - All balance details displayed accurately
    - Entitlement and expiry dates shown
    - Carry-over balance displayed where applicable
    - Visual hierarchy clear
  - **Estimated Days**: 1.5

- [ ] T047 Build Leave Applications Screen with status tracking
  - **Requirement IDs**: FR-LEAVE-4, FR-LEAVE-7
  - **Depends on**: T001, T004, T043, T044
  - **Description**: Create `lib/features/leave/screens/leave_applications_screen.dart`:
    - List of all leave applications (submitted and historical)
    - Each item shows:
      - Date range (start - end date)
      - Number of days
      - Leave type
      - Status badge (PENDING/orange, APPROVED/green, REJECTED/red)
      - Rejection reason (if rejected)
    - Approved applications show cancellation button (where policy allows)
    - Tap item for full details
    - Empty state if no applications
  - **Acceptance Criteria**:
    - All applications listed with correct information
    - Status badges color-coded correctly
    - Rejection reasons displayed
    - Cancellation button functional for approved leaves
    - Tap item shows full details view
  - **Estimated Days**: 1.5

- [ ] T048 Create leave management tests (unit & widget)
  - **Requirement IDs**: FR-LEAVE-1 through FR-LEAVE-7
  - **Depends on**: T043, T044, T045, T046, T047, T007
  - **Description**: Create test files:
    - `test/features/leave/services/leave_service_test.dart` (apply, validate, calculate days, balance)
    - `test/features/leave/screens/leave_application_screen_test.dart` (form validation, date blocking)
    - `test/features/leave/screens/leave_balance_screen_test.dart` (balance display, entitlements)
    - Integration tests: apply for leave → appears in applications with PENDING → receive approval notification → verify APPROVED status
  - **Acceptance Criteria**:
    - Application validation prevents invalid submissions
    - Days calculation correct
    - Balance display accurate
    - UI flows work end-to-end
    - All tests pass with >80% coverage
  - **Estimated Days**: 2

---

## Phase 4: Notifications & Settings

### Notifications Module (FR-NOT-1 through FR-NOT-5)

- [ ] T049 Implement NotificationService and Firebase Cloud Messaging setup
  - **Requirement IDs**: FR-NOT-1, FR-NOT-2, FR-NOT-3, FR-NOT-4, FR-NOT-5
  - **Depends on**: T001, T002, T003, T006
  - **Description**: Create `lib/features/notifications/services/notification_service.dart`:
    - Initialize Firebase Cloud Messaging (FCM)
    - `subscribe()` → subscribes to FCM topic for this user
    - `unsubscribe()` → unsubscribes on logout
    - `sendNotification(type, title, message, relatedEntity)` → calls mock API or local notification service
    - `handleNotificationTap(notification)` → routes to correct screen based on notification type
    - `queryNotificationHistory()` → returns List<Notification> (past notifications)
    - `dismissNotification(notificationId)` → marks notification as read
    - Task event notifications: trigger on task start, pause, complete (with task name, elapsed time)
    - Timesheet reminder: trigger at configured end-of-day time (e.g., 5:30 PM) with pending hours
    - Leave status notifications: trigger when application status changes (submitted, approved, rejected)
  - **Acceptance Criteria**:
    - FCM configured and token obtained on app startup
    - Task event notifications fire with correct payloads
    - Timesheet reminder fires at configured time with pending hours
    - Leave status notifications fire on status change
    - Notification routing works (tap notification → correct screen)
    - History queryable
  - **Estimated Days**: 2

- [ ] T050 Implement platform-specific notification handling (iOS APNs, Android FCM)
  - **Requirement IDs**: FR-NOT-1 through FR-NOT-5
  - **Depends on**: T049
  - **Description**: Create `lib/features/notifications/services/firebase_notification_handler.dart`:
    - Handle FCM payloads on Android with Notification Channel setup
    - Handle APNs payloads on iOS with push notification permissions
    - Configure notification appearance (icon, sound, alert style)
    - Respond to notification taps (foreground and background)
    - Token refresh on FCM token expiry or app update
    - Graceful handling when push permissions denied by user
  - **Acceptance Criteria**:
    - Push notifications deliver on both Android and iOS
    - Notification taps route correctly from both foreground and background states
    - Token refresh works transparently
    - App handles push permission denial gracefully
  - **Estimated Days**: 1.5

- [ ] T051 Create NotificationProvider for notification list and preferences
  - **Requirement IDs**: FR-NOT-4, FR-NOT-5
  - **Depends on**: T002, T049
  - **Description**: Create `lib/features/notifications/providers/`:
    - `notificationListProvider` → StateNotifier<List<Notification>>
    - `notificationPreferencesProvider` → StateNotifier<NotificationPreferences>
    - Preferences: appEnabled, pushEnabled, soundEnabled, quietHours
    - Load preferences from SharedPreferences or local storage on app startup
    - Persist preference changes
  - **Acceptance Criteria**:
    - Notification list updates as notifications received
    - Preferences persist across app restarts
    - In-app notifications respect appEnabled toggle
    - Sound respects soundEnabled toggle and quiet hours
  - **Estimated Days**: 1

- [ ] T052 Build in-app notification overlay widget
  - **Requirement IDs**: FR-NOT-1, FR-NOT-3
  - **Depends on**: T001, T004, T049, T051
  - **Description**: Create `lib/features/notifications/widgets/in_app_notification_overlay.dart`:
    - Toast-style notification that slides in from top or bottom
    - Shows notification title and message
    - Auto-dismiss after 4 seconds or on user tap
    - Color and icon based on notification type (task event, leave status, reminder)
    - Tap to navigate to relevant screen
    - Queue multiple notifications (show in sequence)
  - **Acceptance Criteria**:
    - In-app notification displays for events while app is open
    - Toast dismisses after timeout or tap
    - Tapping notification navigates correctly
    - Queue handles multiple notifications properly
  - **Estimated Days**: 1.5

- [ ] T053 Build Notification History Screen
  - **Requirement IDs**: FR-NOT-4
  - **Depends on**: T001, T004, T049, T051
  - **Description**: Create `lib/features/notifications/screens/notification_history_screen.dart`:
    - List of all notifications (recent first)
    - Each notification shows: title, message, timestamp, read/unread status
    - Unread notifications highlighted or marked with indicator
    - Tap notification to mark as read and navigate to related screen
    - Clear history button (delete all notifications)
    - Empty state if no notifications
  - **Acceptance Criteria**:
    - All notifications listed with correct details
    - Unread status indicated
    - Tap marks as read and navigates
    - Clear history removes all notifications
  - **Estimated Days**: 1

- [ ] T054 Create notification tests and integration with task/leave/timesheet modules
  - **Requirement IDs**: FR-NOT-1 through FR-NOT-5
  - **Depends on**: T049, T050, T051, T052, T053, T007
  - **Description**: Create test files:
    - `test/features/notifications/services/notification_service_test.dart` (send, handle, query)
    - `test/features/notifications/screens/notification_history_screen_test.dart` (list display, tap routing)
    - Integration tests: start task → notification fires with task name and elapsed time; timesheet reminder fires at 5:30 PM; leave approval → notification with status
  - **Acceptance Criteria**:
    - Notification delivery verified for all types
    - In-app notifications render correctly
    - Push notifications route correctly on tap
    - History accurate and queryable
    - All tests pass with >80% coverage
  - **Estimated Days**: 2

---

### Settings & Profile Module (FR-SET-1 through FR-SET-5)

- [ ] T055 Implement SettingsService for profile and preference management
  - **Requirement IDs**: FR-SET-1, FR-SET-2, FR-SET-3, FR-SET-4, FR-SET-5
  - **Depends on**: T001, T003, T006
  - **Description**: Create `lib/features/settings/services/settings_service.dart`:
    - `getUserProfile(userId)` → returns UserProfile with name, email, employeeId, department, designation, picture
    - `updateProfile(name, phone, password)` → calls mock API, validates password strength
    - `updateProfilePicture(imagePath)` → uploads image (or stores locally for mock)
    - `getNotificationPreferences()` → returns NotificationPreferences
    - `updateNotificationPreferences(appEnabled, pushEnabled, soundEnabled, quietHours)` → persists preferences
    - `enablePrivateTime(durationMinutes)` → starts countdown, pauses active task, saves state
    - `disablePrivateTime()` → stops countdown, resumes paused task
    - `logout(scope)` → clears session, settings, cache (scope: "currentDevice" or "allDevices")
    - Password validation: min 8 chars, require uppercase and number
  - **Acceptance Criteria**:
    - Profile data fetched and displayed correctly
    - Profile updates persist
    - Picture upload works (local mock)
    - Notification preferences persist and apply correctly
    - Private time countdown works and resumes task on completion
    - Logout fully clears session and credentials
  - **Estimated Days**: 2

- [ ] T056 Create SettingsProviders for profile, preferences, and private time state
  - **Requirement IDs**: FR-SET-1 through FR-SET-5
  - **Depends on**: T002, T055
  - **Description**: Create `lib/features/settings/providers/`:
    - `userProfileProvider` → FutureProvider<UserProfile>
    - `notificationPreferencesProvider` → StateNotifier<NotificationPreferences>
    - `privateTimeProvider` → StateNotifier<PrivateTime> (enabled, duration, remainingSeconds)
    - Private-time countdown decrement every second when enabled
    - Fire notification when private time ends
    - Auto-pause active task when private time enabled
  - **Acceptance Criteria**:
    - Providers fetch and update data correctly
    - Private time countdown decrements correctly
    - Notification fires at end of countdown
    - Active task pauses when private time starts
  - **Estimated Days**: 1.5

- [ ] T057 Build Settings Home Screen with navigation hubs
  - **Requirement IDs**: FR-SET-1 through FR-SET-5
  - **Depends on**: T001, T004, T055, T056
  - **Description**: Create `lib/features/settings/screens/settings_screen.dart`:
    - Settings navigation hub with sections:
      - Profile (edit name, phone, password)
      - Notifications (app/push/sound toggles, quiet hours)
      - Private Time (enable, duration, countdown)
      - About (app version, contact support)
      - Logout
    - Each section is a card or list item navigating to detail screen
  - **Acceptance Criteria**:
    - All sections render correctly
    - Navigation to detail screens works
    - Logout button accessible
  - **Estimated Days**: 1

- [ ] T058 Build Profile Edit Screen
  - **Requirement IDs**: FR-SET-1, FR-SET-2
  - **Depends on**: T001, T004, T055, T056
  - **Description**: Create `lib/features/settings/screens/profile_edit_screen.dart`:
    - Display current profile info: name, email (read-only), employee ID (read-only), department, designation, picture
    - Editable fields:
      - Name (text input, required, max 100 chars)
      - Phone (text input, optional, phone format validation)
      - Password (requires old password, new password with min 8 chars, uppercase, number)
    - Profile picture upload button (camera/gallery picker)
    - Save and Cancel buttons
    - Show validation errors inline
    - On Save: call SettingsService.updateProfile(), show success message
  - **Acceptance Criteria**:
    - Profile fields display correctly
    - Editable fields allow input
    - Read-only fields show but not editable
    - Picture upload works (local mock)
    - Password validation enforced (min 8, uppercase, number)
    - Save persists changes
    - Success message displayed
  - **Estimated Days**: 1.5

- [ ] T059 Build Notification Preferences Screen
  - **Requirement IDs**: FR-SET-5
  - **Depends on**: T001, T004, T055, T056
  - **Description**: Create `lib/features/settings/screens/notification_preferences_screen.dart`:
    - Toggle: App Notifications (enable/disable in-app notifications)
    - Toggle: Push Notifications (enable/disable push notifications)
    - Toggle: Sound (enable/disable notification sound)
    - Quiet hours configuration:
      - Toggle: Enable Quiet Hours
      - Start time picker (HH:MM)
      - End time picker (HH:MM)
      - During quiet hours, notifications muted unless high-priority (e.g., leave approval)
    - Save and Cancel buttons
    - All changes persisted immediately or on Save
  - **Acceptance Criteria**:
    - Toggles functional and persist across app restarts
    - Quiet hours time picker works
    - Quiet hours logic respected (notifications muted in range)
  - **Estimated Days**: 1

- [ ] T060 Build Private Time Screen with countdown
  - **Requirement IDs**: FR-SET-3
  - **Depends on**: T001, T004, T015, T055, T056
  - **Description**: Create `lib/features/settings/screens/private_time_screen.dart`:
    - Toggle: Enable Private Time (start/stop)
    - Duration picker: 15 minutes, 30 minutes, or custom duration input (in minutes)
    - When enabled:
      - Show countdown timer (MM:SS format)
      - Countdown increments every second
      - Pause and Resume buttons
      - Cancel button (stop private time)
    - Active task pauses when private time starts
    - Notification fires when countdown reaches 0
    - Show paused task indicator
  - **Acceptance Criteria**:
    - Private time toggle enables countdown
    - Duration picker allows selection and custom input
    - Countdown displays and decrements correctly
    - Active task pauses on start
    - Notification fires at end
    - Resume button works if paused mid-countdown
  - **Estimated Days**: 1.5

- [ ] T061 Build Logout Confirmation Dialog
  - **Requirement IDs**: FR-SET-4
  - **Depends on**: T001, T055, T056
  - **Description**: Create `lib/features/settings/widgets/logout_dialog.dart`:
    - Confirmation dialog: "Are you sure you want to log out?"
    - Two radio button options:
      - "Current Device Only" (clears session on this device only)
      - "All Devices" (clears session on all devices, future logins require re-auth)
    - Cancel and Logout buttons
    - On Logout: call SettingsService.logout(scope), clear all cached data, redirect to Login screen
  - **Acceptance Criteria**:
    - Dialog appears on logout button tap
    - Radio button selection toggleable
    - Logout clears session and cache correctly
    - Redirect to login screen works
    - "All Devices" option properly scoped in mock API
  - **Estimated Days**: 1

- [ ] T062 Create settings tests (unit & widget)
  - **Requirement IDs**: FR-SET-1 through FR-SET-5
  - **Depends on**: T055, T056, T057, T058, T059, T060, T061, T007
  - **Description**: Create test files:
    - `test/features/settings/services/settings_service_test.dart` (update profile, preferences, private time, logout)
    - `test/features/settings/screens/profile_edit_screen_test.dart` (form validation, update)
    - `test/features/settings/screens/notification_preferences_screen_test.dart` (toggles, quiet hours)
    - Integration tests: edit profile → changes persist; enable private time → task pauses → countdown fires; logout → session cleared
  - **Acceptance Criteria**:
    - Profile updates verified
    - Preference toggles work
    - Private time countdown functional
    - Logout clears all state
    - All tests pass with >80% coverage
  - **Estimated Days**: 2

---

## Phase 5: Polish & Integration

### Cross-Module Integration & Sync

- [ ] T063 Implement SyncQueueService for offline action reconciliation
  - **Requirement IDs**: Timer persistence, offline support (all modules)
  - **Depends on**: T002, T005, T015, T021, T029, T043
  - **Description**: Create `lib/core/sync/sync_queue_service.dart`:
    - `queueAction(type, entityId, payload)` → adds SyncAction to queue
    - `processSyncQueue()` → on reconnect, processes queued actions in order:
      - Task actions: start, pause, complete
      - Timesheet submissions
      - Leave applications
    - Persist queue to local storage on pause
    - Restore queue on app launch if offline
    - Handle partial failures (retry failed actions on next reconnect)
    - Deduplicate actions (e.g., don't queue duplicate start if already failed)
    - Emit sync status (syncing, synced, error) for UI feedback
  - **Acceptance Criteria**:
    - Queue persists across app restarts
    - Actions processed in order on reconnect
    - Partial failures retried
    - Sync status observable for UI (loading indicator)
    - No data loss during offline periods
  - **Estimated Days**: 2

- [ ] T064 Integrate offline timer sync with task completion offline
  - **Requirement IDs**: Timer persistence, task completion reconciliation
  - **Depends on**: T015, T021, T063
  - **Description**: Create sync logic for offline task actions:
    - When task completed offline:
      - Record completion locally
      - Queue "task_complete" action with elapsed time and timestamp
      - On reconnect, send completion to server with device elapsed time
      - If server has different total, reconcile (use server's value if significant divergence)
    - Optimize: if user starts and completes task entirely offline, queue one "task_complete" action (not start + complete)
    - Test scenario: start task online → go offline → pause → go online → complete task → sync
  - **Acceptance Criteria**:
    - Task completion queued correctly when offline
    - Sync reconciles device elapsed with server
    - No data loss on task completion offline
    - Integration test: offline task completion flow succeeds
  - **Estimated Days**: 1.5

- [ ] T065 Integrate task events (start/pause/complete) with notifications
  - **Requirement IDs**: FR-NOT-1, FR-TASK-4, FR-TASK-7, FR-TASK-8
  - **Depends on**: T021, T049, T052
  - **Description**: Wire TaskService events to NotificationService:
    - On `TaskService.startTask()` → trigger notification "Task [name] started at [time]"
    - On `TaskService.pauseTask()` → trigger notification "Task [name] paused (elapsed: [time])"
    - On `TaskService.completeTask()` → trigger notification "Task [name] completed (total: [time])"
    - Notifications show as in-app toast when app is open
    - Notifications sent as push when app is backgrounded
    - Include actual elapsed time and task name in notification payload
  - **Acceptance Criteria**:
    - Notifications fire for all task state changes
    - Notifications include correct task name and elapsed time
    - In-app notifications appear while app open
    - Push notifications deliver when backgrounded
  - **Estimated Days**: 1

- [ ] T066 Integrate timesheet submission with notifications and reminders
  - **Requirement IDs**: FR-NOT-2, FR-TIME-4
  - **Depends on**: T029, T049, T052
  - **Description**: Wire TimesheetService events and scheduler to NotificationService:
    - On `TimesheetService.submitTimesheet()` → trigger notification "Timesheet submitted for [date] (total: [hours])"
    - Schedule end-of-day reminder at configured time (e.g., 5:30 PM):
      - Fetch pending logged hours (submitted vs. unsubmitted)
      - Trigger notification "Unsubmitted hours: [hours]. Tap to view timesheet."
      - Tap navigates to Timesheet screen
    - Use platform-specific scheduling (flutter_local_notifications for iOS/Android)
  - **Acceptance Criteria**:
    - Submission notification fires with correct hours
    - End-of-day reminder fires at configured time
    - Reminder shows pending hours
    - Tap reminder navigates to Timesheet screen
  - **Estimated Days**: 1

- [ ] T067 Integrate leave status changes with notifications
  - **Requirement IDs**: FR-NOT-3, FR-LEAVE-4
  - **Depends on**: T043, T049, T052
  - **Description**: Wire LeaveService events to NotificationService:
    - On leave application submitted → notification "Leave application submitted for [type] on [dates]"
    - On leave status changed to APPROVED → notification "Leave approved for [dates]"
    - On leave status changed to REJECTED → notification "Leave rejected for [dates]" with reason if provided
    - Notifications tappable to navigate to Leave screen
  - **Acceptance Criteria**:
    - All leave events trigger notifications
    - Notifications include relevant dates and status
    - Tap notification navigates to leave screen
    - Rejection reason included in notification message
  - **Estimated Days**: 0.5

- [ ] T068 Implement project progress auto-update on task completion
  - **Requirement IDs**: FR-PROJ-2, FR-TASK-8
  - **Depends on**: T021, T037
  - **Description**: Wire task completion events to ProjectService:
    - When task completes (status → COMPLETED):
      - Recalculate project progress (completed tasks / total tasks)
      - Update ProjectProvider with new progress percentage
      - Dashboard and Project screens reflect progress change within 500ms
    - Optimize: batch recalculation if multiple tasks complete rapidly
  - **Acceptance Criteria**:
    - Project progress updates in real-time on task completion
    - UI reflects progress change within 500ms
    - Dashboard and Project screens show consistent progress
  - **Estimated Days**: 1

- [ ] T069 Create integration tests for cross-module flows
  - **Requirement IDs**: All (integration)
  - **Depends on**: T063 through T068
  - **Description**: Create comprehensive integration tests:
    - `test/integration/auth_to_dashboard_flow_test.dart` (login → dashboard loads with summary)
    - `test/integration/task_lifecycle_test.dart` (create → start → pause → complete, verify status progression)
    - `test/integration/offline_sync_test.dart` (start task online → go offline → complete → go online → sync)
    - `test/integration/project_progress_update_test.dart` (complete task → project progress updates)
    - `test/integration/notification_delivery_test.dart` (task start → notification delivered)
  - **Acceptance Criteria**:
    - All major flows execute end-to-end without errors
    - Data consistency across modules verified
    - Offline scenarios handled correctly
    - Sync queue processes correctly on reconnect
    - All integration tests pass
  - **Estimated Days**: 2

---

### UI Polish & Accessibility

- [ ] T070 Implement theme customization and dark mode support
  - **Requirement IDs**: FR-SET-5 (notification preferences scope)
  - **Depends on**: T001
  - **Description**: Enhance `lib/core/theme/app_theme.dart`:
    - Extend theme with light and dark variants
    - Material Design 3 color scheme for both modes
    - ThemeProvider for global theme state
    - Settings screen option to toggle dark mode
    - Persist preference to storage
  - **Acceptance Criteria**:
    - Light and dark themes apply consistently across all screens
    - Theme toggle in settings works
    - Preference persists across app restarts
    - All text readable in both modes
  - **Estimated Days**: 1

- [ ] T071 Implement accessibility compliance (semantic labels, text scaling)
  - **Requirement IDs**: FR-* (all modules)
  - **Depends on**: T011 through T062 (all screens)
  - **Description**: Audit and enhance accessibility:
    - Add semantic labels to all interactive elements (buttons, inputs, indicators)
    - Ensure color is not sole differentiator (use icons, text labels)
    - Support system text scaling up to 200%
    - Test with TalkBack (Android) and VoiceOver (iOS)
    - Minimum touch target size 48×48 dp
  - **Acceptance Criteria**:
    - TalkBack/VoiceOver can navigate all screens
    - All interactive elements have meaningful labels
    - Text scales to 200% without overflow
    - Touch targets meet 48×48 dp minimum
    - High-contrast mode tested
  - **Estimated Days**: 2

- [ ] T072 Enhance error handling and user feedback
  - **Requirement IDs**: FR-* (all modules)
  - **Depends on**: T001, T011 through T062
  - **Description**: Improve error UX across app:
    - Create consistent `ErrorDialog` and `ErrorToast` widgets
    - All API errors caught and formatted for user (no stack traces shown)
    - Network timeouts handled with retry option
    - Form validation errors appear inline adjacent to field
    - Loading states shown for all async operations
    - Success messages displayed for user actions
  - **Acceptance Criteria**:
    - No unhandled exceptions shown to user
    - All errors have human-readable messages
    - Retry options available for network errors
    - Loading indicators appear during async ops
    - Success messages confirm user actions
  - **Estimated Days**: 1.5

- [ ] T073 Optimize app performance and reduce UI jank
  - **Requirement IDs**: FR-HOME-3 (real-time timer without jank)
  - **Depends on**: T015, T018, T031
  - **Description**: Performance optimization:
    - Profile timer updates for jank (use DevTools Performance)
    - Optimize real-time timer stream (Debounce/Throttle rapid updates)
    - Lazy-load task list and project lists (pagination or virtual scrolling)
    - Cache API responses appropriately
    - Profile widget builds and optimize excessive rebuilds
    - Run `flutter test --coverage` and exceed 80% coverage
  - **Acceptance Criteria**:
    - Timer updates smooth at 60fps (no jank)
    - List scrolling smooth with 100+ items
    - API responses cached and reused
    - No excessive widget rebuilds
    - Code coverage >80%
  - **Estimated Days**: 2

- [ ] T074 Create app walkthrough/onboarding flow (optional, post-MVP)
  - **Requirement IDs**: N/A (polish feature)
  - **Depends on**: All screens
  - **Description**: Optional feature (post-MVP):
    - Quick tour on first app launch (skip option)
    - Highlight key features (timer, task creation, timesheet)
    - Can be disabled in settings
  - **Acceptance Criteria**:
    - Walkthrough displays on first launch only
    - Can skip and go directly to dashboard
    - Can re-enable walkthrough in settings
  - **Estimated Days**: 1.5

---

### Testing & QA Finalization

- [ ] T075 Create comprehensive test suite summary and coverage report
  - **Requirement IDs**: All (QA validation)
  - **Depends on**: T007, T014, T020, T028, T036, T042, T048, T054, T062, T069
  - **Description**: Compile final test metrics:
    - Run `flutter test --coverage` on all tests
    - Generate coverage report (target >80% line coverage)
    - List all test files and test case counts
    - Document test categories (unit, widget, integration, acceptance)
    - Create test execution checklist
  - **Acceptance Criteria**:
    - Coverage report generated and >80%
    - All test files listed and passing
    - Test categories documented
    - Coverage gaps identified (if any) with remediation plan
  - **Estimated Days**: 1

- [ ] T076 Platform-specific testing (iOS and Android)
  - **Requirement IDs**: FR-* (all, cross-platform)
  - **Depends on**: All screens (T011 through T062)
  - **Description**: Manual testing on physical/emulated devices:
    - iOS iPhone SE (small screen) and iPhone 14 (larger screen)
    - Android Pixel 3 (small) and Pixel 6 (larger)
    - Test all major flows on each platform
    - Verify platform-specific features (notifications, secure storage, OAuth)
    - Capture screenshots for documentation
    - Test landscape orientation
  - **Acceptance Criteria**:
    - All screens render correctly on test devices
    - Platform-specific features work (push notifications, secure storage)
    - No platform-specific crashes or errors
    - Landscape orientation supported
    - Screenshots captured for documentation
  - **Estimated Days**: 2

- [ ] T077 Performance benchmarking and optimization
  - **Requirement IDs**: FR-HOME-3 (real-time updates), FR-TASK-3 (task list performance), FR-TIME-1 (calendar performance)
  - **Depends on**: T018, T024, T031, T073
  - **Description**: Benchmark key user flows:
    - Measure dashboard load time (target <2s)
    - Measure task list scroll performance (target 60fps)
    - Measure calendar view load time (target <2s)
    - Measure timer update latency (target <500ms from state change to UI)
    - Profile memory usage; target <150MB typical usage
  - **Acceptance Criteria**:
    - All performance targets met
    - No memory leaks detected
    - Benchmarks documented with baseline and optimizations applied
  - **Estimated Days**: 1.5

- [ ] T078 Create user documentation and setup guide
  - **Requirement IDs**: All (documentation)
  - **Depends on**: All other tasks
  - **Description**: Documentation:
    - User guide (how to clock in, create tasks, submit timesheet, apply leave)
    - Troubleshooting guide (common issues and solutions)
    - Feature screenshots with annotations
    - Keyboard shortcuts (if applicable)
    - FAQ section
    - Support contact information
  - **Acceptance Criteria**:
    - All major features documented
    - Screenshots clear and annotated
    - Troubleshooting covers common issues
    - Documentation is user-friendly (non-technical language where possible)
  - **Estimated Days**: 1

- [ ] T079 Final QA review and release readiness checklist
  - **Requirement IDs**: All (QA gate)
  - **Depends on**: T075, T076, T077
  - **Description**: Release readiness verification:
    - Test checklist: all acceptance criteria verified
    - Code review: `flutter analyze` clean, formatting correct
    - Security review: no hardcoded secrets, secure storage used
    - Changelog: document all features, bug fixes, known limitations
    - Release notes: user-facing summary
    - Verify mock APIs comprehensive and realistic
  - **Acceptance Criteria**:
    - All acceptance criteria verified
    - Code analysis clean
    - No security issues
    - Changelog complete
    - Release notes written
    - App ready for beta/production release
  - **Estimated Days**: 1.5

---

## Task Summary

**Total Tasks**: 79  
**Estimated Duration**: ~90-110 working days (across team)

### Tasks by Phase

| Phase | Task Count | Estimated Days | Key Deliverables |
|-------|-----------|-----------------|------------------|
| Phase 0 | 7 | 8.5 | Core infrastructure, state management, navigation, lifecycle |
| Phase 1 | 8 | 15 | Authentication (email/OAuth), Dashboard with real-time timer |
| Phase 2 | 8 | 18 | Task management with timer, Timesheet with calendar |
| Phase 3 | 5 | 11 | Project visibility with progress tracking, Leave management |
| Phase 4 | 9 | 16 | Notifications (task/timesheet/leave), Settings/Profile management |
| Phase 5 | 5 | 21 | Integration, sync, testing, polish, accessibility, performance |

### Critical Path

1. **Phase 0** (8.5 days): Infrastructure and config
2. **Phase 1** (15 days): Auth & Dashboard (gates all other features)
3. **Phase 2** (18 days): Tasks & Timesheet (core value drivers)
4. **Phase 3** (11 days): Projects & Leave (secondary value)
5. **Phase 4** (16 days): Notifications & Settings (enhancers)
6. **Phase 5** (21 days): Integration, testing, polish, release prep

### Parallelization Opportunities

- **During Phase 1**: Auth and Dashboard can be developed in parallel by separate team members after Phase 0 infrastructure ready
- **During Phase 2**: Task and Timesheet modules can be developed in parallel after core infrastructure stable
- **During Phase 3**: Projects and Leave can be developed in parallel
- **During Phase 4**: Notifications and Settings can be developed in parallel
- **Integration tasks (T063-T069)** can begin as soon as Phase 2-4 screens complete (do not need all features 100% complete)

### Dependencies

- All Phase 1-4 features depend on Phase 0 infrastructure (T001-T007)
- Phase 2 Tasks depend on Phase 1 (active task state from dashboard)
- Phase 4 Notifications depend on Phase 2+ (task/timesheet/leave events)
- Phase 5 Integration depends on Phase 1-4 completion

---

## Acceptance Criteria Summary

**Authentication & Authorization** (T008-T014)
- [ ] Email/password login with credentials validation
- [ ] OAuth (Google & Microsoft) flows working
- [ ] Remember Me persists email across sessions
- [ ] Session validation prevents stale tokens
- [ ] Logout clears all cached data

**Real-Time Dashboard** (T015-T020)
- [ ] Timer increments reliably every 100ms with <500ms UI update latency
- [ ] Online/offline status indicator accurate
- [ ] All summary components (clock-in, active hours, total time, active task) display correctly
- [ ] Quick-action buttons functional

**Task Management** (T021-T028)
- [ ] Create, list, and detail screens fully functional
- [ ] Task status lifecycle (NEW → IN_PROGRESS → OVERDUE → COMPLETED) enforced
- [ ] Single active task constraint maintained
- [ ] Overdue detection triggers when elapsed > estimated
- [ ] Completion confirmation dialog prevents accidental completion

**Timesheet Logging** (T029-T036)
- [ ] Calendar displays current month with hours logged per date
- [ ] Hour logging via time range picker works
- [ ] Submit locks timesheet
- [ ] History tracks submissions with approval status
- [ ] Totals calculated correctly (logged vs. submitted)

**Project Visibility** (T037-T042)
- [ ] Project list displays with progress, dates, team members
- [ ] Progress bar color-coded and calculated as completed/total
- [ ] Days remaining calculated with overdue warning
- [ ] Team avatar display with "+X" indicator
- [ ] Task breakdown shows by status

**Leave Management** (T043-T048)
- [ ] Application form validates dates (no past, no overlaps, sufficient balance)
- [ ] Status workflow (PENDING → APPROVED/REJECTED) tracked
- [ ] Balance display accurate per leave type
- [ ] Entitlements show allocation and expiry dates

**Notifications** (T049-T054)
- [ ] Task event notifications fire (start/pause/complete) with task name and elapsed time
- [ ] Timesheet end-of-day reminder fires at configured time with pending hours
- [ ] Leave status change notifications deliver on approval/rejection
- [ ] In-app notifications appear as toast when app open
- [ ] Push notifications deliver when app backgrounded

**Settings & Profile** (T055-T062)
- [ ] Profile display and edit functional
- [ ] Notification preferences toggles work
- [ ] Private time countdown works and pauses active task
- [ ] Logout clears session and redirects to login

**Offline Support** (T063-T068)
- [ ] Sync queue persists across app restarts
- [ ] Task actions queued when offline and processed on reconnect
- [ ] Timer reconciliation handles device/server divergence
- [ ] No data loss during offline periods

**Cross-Platform & Polish** (T070-T079)
- [ ] Dark mode supported
- [ ] Accessibility: TalkBack/VoiceOver functional, 48×48dp touch targets, semantic labels
- [ ] Performance: Dashboard <2s load, 60fps scrolling, <500ms timer latency
- [ ] >80% test coverage
- [ ] iOS and Android tested on physical devices
- [ ] Documentation complete
- [ ] Flutter analyze clean, no warnings

---

## Testing Strategy

### Unit Tests (Per Module)
- Services: CRUD, state transitions, calculations
- Models: serialization, validation, immutability
- Utilities: formatting, calculations
- **Target**: >80% line coverage per module

### Widget Tests (Per Screen/Feature)
- Form validation and error display
- State updates reflection in UI
- Navigation between screens
- User interactions (tap, scroll, etc.)
- Loading and error states

### Integration Tests
- Cross-module flows: login → dashboard → create task → complete → timesheet
- Offline scenarios: action queuing, sync reconciliation
- Notification delivery and routing
- Real-time timer accuracy
- Project progress updates on task completion

### Acceptance Tests
- Verify each acceptance scenario from spec (all GivenWhenThen scenarios tested)
- Manual testing on iOS and Android devices
- Accessibility testing with TalkBack/VoiceOver

### Performance Tests
- Timer update latency (<500ms)
- Dashboard load time (<2s)
- Task/project list scroll performance (60fps)
- Memory profiling (<150MB typical)

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Timer sync divergence (device vs. server) | Medium | Medium | Implement 30s validation check with divergence threshold and reconciliation algorithm |
| Offline action race conditions | Low | High | Use sync queue with deduplication and ordering |
| Push notification delivery failure | Medium | Medium | Implement fallback to in-app notifications; test FCM/APNs thoroughly |
| Memory leaks from timer streams | Medium | High | Profile with DevTools; unsubscribe timers on dispose |
| State management complexity | Medium | Medium | Establish clear provider/notifier ownership and document state flow |
| Cross-platform compatibility | Low | High | Test all major screens on iOS/Android devices early and often |
| Accessibility compliance | Medium | Low | Audit with TalkBack/VoiceOver during development, not at end |

---

## Success Criteria

✅ **Phase 0 Complete**: Infrastructure in place, no blockers for feature development  
✅ **Phase 1 Complete**: Users can authenticate and see real-time dashboard  
✅ **Phase 2 Complete**: Users can manage tasks with timers and submit timesheets  
✅ **Phase 3 Complete**: Users can view projects and apply for leave  
✅ **Phase 4 Complete**: Users receive notifications for events and can customize settings  
✅ **Phase 5 Complete**: App is polished, tested, accessible, performant, and ready for release  

**Final Verification**:
- All 79 tasks completed
- >80% test coverage
- Zero critical/high-severity defects
- iOS and Android manual testing passed
- Accessibility audit passed
- Performance benchmarks met
- Documentation complete
- Release notes and changelog ready
