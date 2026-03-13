# Implementation Plan: InTimePro Flutter Mobile App

**Feature Branch**: `002-itp-flutter-app`  
**Status**: Active Planning Phase  
**Last Updated**: March 13, 2026  
**Plan Version**: 1.0.0

---

## Executive Summary

The InTimePro Flutter Mobile App is a cross-platform time tracking and task management solution targeting iOS, Android, Web, Windows, macOS, and Linux. This plan translates the feature specification into a module-based architecture organized around eight functional domains: Authentication, Dashboard, Task Management, Project Management, Timesheet, Leave Management, Notifications, and Settings/Profile.

**Key Architectural Decisions** (Clarified in Specification):
- **API Strategy**: Mock APIs with hardcoded in-memory data for rapid iteration during feature development
- **Offline Timer Behavior**: Task timers continue running locally and reconcile with server on reconnect
- **Navigation Pattern**: Bottom tab navigation with 5-6 primary tabs (Dashboard, Tasks, Timesheet, Projects, Leave, Settings)
- **Timer Time Source**: Server-synced timer with periodic validation; device clock drives real-time UI updates
- **Background Persistence**: Task timer state persists locally; app resumes counting on relaunch with server reconciliation

---

## Technical Context

### Project Structure
- **Framework**: Flutter 3.19+ (Dart 3.11+)
- **Minimum Versions**: iOS 13+, Android 8.0+
- **Target Platforms**: iOS, Android, Web, Windows, macOS, Linux
- **Existing Code Location**: `lib/core/network/mock/mock_api_service.dart`
- **Module Root**: `lib/features/` (auth, dashboard, task, timesheet, projects, leave, notifications, settings)
- **Shared Utilities**: `lib/core/` (config, logging, navigation, network, providers, storage, theme)

### Key Dependencies
- **State Management**: (NEEDS CLARIFICATION - Riverpod, Bloc, or Provider?)
- **Secure Storage**: flutter_secure_storage for credential storage
- **Notifications**: firebase_messaging (FCM for Android/Web), flutter_local_notifications
- **Offline Sync**: (NEEDS CLARIFICATION - Drift/SQLite local database or in-memory only?)
- **HTTP Client**: http or Dio for API calls
- **Local Persistence**: SharedPreferences for app preferences, platform-specific secure storage for tokens

### Known Unknowns
1. **State Management Library**: Multiple options exist (Riverpod, Bloc, Provider). Requires architectural decision on how global state (authenticated user, active task, timer) flows through the app.
2. **Offline Data Storage**: For Phase 1 MVP, mock API can use in-memory Map<String, List<T>>. For persistence across app restarts, need to decide: Drift-based SQL database, Hive key-value store, or encrypted SharedPreferences.
3. **Timer Accuracy & Sync Strategy**: Clarify sync frequency (every 30s, 1m, 5m) and reconciliation logic when offline timer diverges from server time.
4. **Push Notification Configuration**: Firebase project setup, APNs certificate provisioning, and FCM token lifecycle management.
5. **OAuth Configuration**: Microsoft Azure AD and Google OAuth client IDs/secrets for mobile app flow (PKCE).

---

## Constitution Check

### BA Principles (Requirements Traceability & User-Story-Driven Design)

✅ **Principle I — Requirements Traceability**
- All planned features trace to requirement IDs (FR-LOGIN-*, FR-HOME-*, FR-TASK-*, FR-PROJ-*, FR-TIME-*, FR-LEAVE-*, FR-NOT-*, FR-SET-*)
- Each component is mapped to one or more FR-* identifier (see Section 3: Component Breakdown)

✅ **Principle II — User-Story-Driven Design**
- Implementation plan organizes work around 8 user stories from the specification (Stories 1–8)
- Each story targeted to a functional module with clear delivery value

✅ **Principle III — Acceptance Criteria Completeness**
- All user stories in the specification include Given/When/Then acceptance criteria
- Plan includes mapping of each story to test strategy in Section 6 (Integration Points)

✅ **Principle IV — Module Boundary Integrity**
- Plan strictly respects the 8-module boundary: Authentication, Dashboard, Task Management, Project Management, Timesheet, Leave Management, Notifications, Settings
- Cross-module contracts defined in Section 5 (Data Flow & State Management)

✅ **Principle V — Stakeholder Alignment**
- Spec includes clarification session (Clarifications, Session 2026-03-13) documenting 5 architectural decisions
- No scope change proposed in this plan; all scope aligns with the approved specification

---

### QA Principles (Test-First & Cross-Platform Coverage)

✅ **Principle VI — Test-First Validation**
- Plan includes test structure for each module (Section 3: Component Breakdown → Test Strategy)
- Widget tests and unit tests will follow Red → Green → Refactor cycle for all models and services

⚠️ **Principle VII — Acceptance Test Coverage (NON-NEGOTIABLE)**
- Each FR-* requirement will have ≥1 automated test
- Plan identifies integration test points (Section 5: Integration Points) to verify cross-module interactions
- Test coverage gaps will be resolved before story completion

⚠️ **Principle VIII — Regression Safety**
- Full test suite must pass before any PR merge
- Flaky tests flagged and fixed within same sprint

⚠️ **Principle IX — Cross-Platform Testing**
- Widget tests must execute on Android and iOS emulators/simulators
- Platform-specific behavior (notifications, secure storage) will have dedicated test cases per platform
- Web and desktop platforms smoke-tested at each release milestone

⚠️ **Principle X — Defect Lifecycle Management**
- Every defect will reference the requirement ID (FR-*) and test case that exposed it
- Critical/high-severity defects block story completion

---

### Developer Principles (Architecture & State Management)

✅ **Principle XI — Module-Based Architecture (NON-NEGOTIABLE)**
- Plan enforces 8-module boundary with clear directory structure (Section 3)
- Each module has: `models/`, `services/`, `screens/`, `widgets/`, `state/` subdirectories
- Shared utilities isolated in `lib/core/` and `lib/shared/`
- Cross-module communication only through defined service interfaces

⚠️ **Principle XII — State Management Consistency (NON-NEGOTIABLE)**
- **NEEDS CLARIFICATION**: Which state management library (Riverpod, Bloc, Provider)?
- Once chosen, will be applied uniformly across all 8 modules
- Global state (authenticated user, active task, connection, timer) will be managed at app scope
- Real-time timer state persists across screen navigations
- All state mutations will trace through defined actions/notifiers

✅ **Principle XIII — Security Implementation**
- All API calls over HTTPS (TLS 1.2+)
- Credentials encrypted with AES-256 via flutter_secure_storage
- OAuth flows use PKCE; no client secrets bundled
- Session tokens cleared on logout
- Input validation before all API calls

✅ **Principle XIV — Performance Standards**
- Dashboard real-time updates reflect within 1 second (SC-002)
- Task status transitions render within 500 ms (SC-004)
- Calendar timesheet view loads within 2 seconds (SC-013)
- Timer maintains accuracy with zero data loss during pause/resume (SC-011)
- App remains responsive with up to 100 active tasks per employee (SC-012)

✅ **Principle XV — Code Quality & Standards (NON-NEGOTIABLE)**
- `flutter analyze` must report zero issues before every commit
- `dart format` applied to all modified files
- Public APIs documented with clear comments
- Magic numbers and hard-coded strings extracted to named constants
- Business-logic test coverage ≥80% line coverage

---

### UI/UX Principles (Design & Accessibility)

✅ **Principle XVI — Platform Design Adherence (NON-NEGOTIABLE)**
- Android screens follow Material Design 3
- iOS screens follow Apple Human Interface Guidelines (HIG)
- Adaptive widgets used where behavioral differences exist
- Platform-specific conventions preserved (back gesture on Android, swipe-to-dismiss on iOS)

✅ **Principle XVII — Accessibility Compliance (NON-NEGOTIABLE)**
- Every interactive element has meaningful semantic label for TalkBack/VoiceOver
- Dynamic text sizing supported up to 200% system font scale
- Color not sole differentiator; icons/labels accompany status indicators
- Touch targets ≥48×48 dp
- High-contrast mode tested on all core screens

✅ **Principle XVIII — Component Reusability & Design Consistency**
- Colors, typography, spacing sourced from `lib/core/theme/` — never hard-coded
- Status badges (Pending/orange, Approved/green, Rejected/red) use canonical `StatusBadge` widget
- Task priority indicators, timer controls, notification items each have single reusable widget
- New custom widgets created only when existing widgets cannot be parameterized

✅ **Principle XIX — Responsive & Adaptive Layout**
- Layouts tested on small phones (≥360 dp), large phones, tablets
- No horizontal scrolling on vertical content
- Calendar, task lists, project cards use flexible layout constructs
- Portrait and landscape orientations both functional
- Web and desktop smoke-tested at each release milestone

✅ **Principle XX — User Feedback & Interaction Standards**
- Loading indicators during all async operations (auth, data fetch, submission)
- Success messages within 500 ms of server acknowledgement
- Error messages human-readable and actionable
- Confirmation dialogs before destructive actions (task complete, timesheet submit, logout)
- Form validation feedback inline adjacent to offending field

---

## Quality Gates Assessment

| Gate | Status | Notes |
|------|--------|-------|
| Gate 1: Spec Review | ✅ PASS | Spec includes mapped FR-*, prioritized user stories, complete acceptance criteria |
| Gate 2: Plan Review | ⚠️ CONDITIONAL | Plan passes Constitution Check; NEEDS CLARIFICATION items documented in Section 2 (Technical Context) |
| Gate 3: Design Review | ⏳ PENDING | UI/UX wireframes/designs to be reviewed against Principles XVI–XX before screen implementation; deferred to Phase 1 |
| Gate 4: Test Readiness | ⏳ PENDING | Failing test stubs to be created before implementation; architectural decisions (state management library) must be finalized first |
| Gate 5: PR Approval | ⏳ PENDING | Full test suite must pass; `flutter analyze` clean; acceptance tests green; cross-platform verification required |
| Gate 6: Story Completion | ⏳ PENDING | Acceptance criteria verified; no critical/high defects; cross-platform smoke tests; accessibility spot-check |

**Conditional Gate 2 Approval**: This plan may proceed to Phase 0 Research upon resolution of the three NEEDS CLARIFICATION items in the Technical Context section.

---

## Phase 0: Research & Clarifications

### Research Tasks

The following research tasks will resolve NEEDS CLARIFICATION items and establish best practices for the chosen technology stack.

#### Task 0.1: State Management Architecture Decision
**Goal**: Evaluate and select the state management library for the ITP app  
**Context**: Must be single, documented solution applied uniformly across all 8 modules. Must support global state (authenticated user, active task, timer) persisting across screen navigations.

**Research Outputs**:
- Comparison matrix: Riverpod vs. Bloc vs. Provider (complexity, learning curve, ecosystem support, timer/interval support)
- Decision: Selected library and rationale
- Architecture diagram: How global state (user, active task, timer) flows through app layers
- Example notifier/provider definition for active task state

**Owner**: Developer Lead  
**Timeline**: Phase 0, Day 1–2  

---

#### Task 0.2: Offline Data Persistence Strategy
**Goal**: Determine how task timers, tasks, and other mutable state persist across app restart and offline periods

**Context**: 
- Spec requires timer state to resume after app force-close with server reconciliation (FR-BG-*)
- Mock API currently uses in-memory data; for persistence, need persistent storage strategy
- Must support offline timer accuracy (device clock drives timer until sync)

**Research Outputs**:
- Decision: Drift-based SQLite, Hive key-value store, or enhanced in-memory with JSON serialization to local files
- Database schema (or Hive box structure) for minimal MVP: Task, TimerSession, SyncMetadata
- Reconciliation algorithm: How offline timer divergence is resolved on reconnect
- Implementation example: Timer save on pause/background, restore on app launch

**Owner**: Developer Lead  
**Timeline**: Phase 0, Day 1–2  

---

#### Task 0.3: Timer Sync & Validation Strategy
**Goal**: Clarify when the device timer validates against the server, how divergence is handled, and sync frequency

**Context**:
- Spec: "Server-synced timer with periodic validation; device clock drives real-time updates"
- Need concrete schedule: every 30s, 1m, 5m? On background/foreground transition? On explicit check-in button?
- Divergence handling: If offline timer is ahead/behind by >5s, reconcile silently or show warning?

**Research Outputs**:
- Sync schedule and validation triggers
- Divergence threshold and reconciliation logic
- Mock API endpoint specification for timer validation
- Example service code: validateTimerWithServer() method

**Owner**: Developer Lead, Backend Liaison  
**Timeline**: Phase 0, Day 2–3  

---

#### Task 0.4: Push Notification Configuration & Platform Setup
**Goal**: Document Firebase Cloud Messaging (FCM), Apple Push Notification (APNs) setup, and token lifecycle

**Context**:
- Need to deliver task event notifications (start, pause, complete), timesheet reminders, and leave status updates
- Must work on Android, iOS, Web, desktop platforms
- Requires Firebase project, APNs certificate, and token refresh strategy

**Research Outputs**:
- Firebase project setup checklist (enable FCM, obtain server API key)
- APNs certificate provisioning steps (develop, production certificates)
- Token lifecycle: obtain on login, refresh on server renewal, clear on logout
- Platform-specific delivery configuration (Android Notification Channel, iOS APNs payload format)
- Example implementation: FirebaseMessaging integration and notification tap routing

**Owner**: DevOps / Mobile Infra Lead  
**Timeline**: Phase 0, Day 3–4  

---

#### Task 0.5: OAuth Integration for Microsoft & Google
**Goal**: Establish PKCE-based OAuth flow implementation for mobile app

**Context**:
- Spec requires Microsoft account and Google OAuth authentication (FR-LOGIN-5)
- Mobile apps must use PKCE (Proof Key for Code Exchange); client secrets must not be embedded
- Must handle token refresh, session persistence, and graceful fallback to email/password

**Research Outputs**:
- OAuth provider configurations: Microsoft Azure AD app registration, Google OAuth Credential setup
- PKCE flow diagram: authorization code request, token exchange, refresh token handling
- Platform package recommendations: google_sign_in, flutter_appauth, or equivalent
- Implementation example: OAuthService with login, logout, token refresh methods
- Fallback strategy when OAuth provider unavailable

**Owner**: Developer Lead, Security Lead  
**Timeline**: Phase 0, Day 3–4  

---

### Research Consolidation

**Output**: `specs/002-itp-flutter-app/research.md`

Format:
```markdown
## Research Summary

### State Management (Task 0.1)
- Decision: [Selected library]
- Rationale: [Why chosen]
- Alternatives: [Evaluated but not chosen]
- Architecture: [Global state flow diagram]

### Data Persistence (Task 0.2)
- Decision: [Selected storage strategy]
- Rationale: [Why chosen]
- Schema/Structure: [Minimal data model]
- Reconciliation: [Divergence handling algorithm]

[... similar sections for Tasks 0.3, 0.4, 0.5 ...]
```

---

## Phase 1: Design & Architecture

### 1. Architecture Overview

#### 1.1 Layered Architecture

The app follows a **layered architecture** organized around 8 functional modules, each with internal separation of concerns:

```
┌─────────────────────────────────────────────────────┐
│              Presentation Layer (UI)                 │
│  ┌────────────────┬─────────┬────────┬──────────┐   │
│  │ Auth Screens   │Dashboard│ Tasks  │ Timesheet│   │
│  │ Projects  Leave│Settings │Notif.  │          │   │
│  └────────────────┴─────────┴────────┴──────────┘   │
├─────────────────────────────────────────────────────┤
│              State Management Layer                  │
│  Riverpod Providers / Bloc Cubits / Notifiers      │
│  ┌────────┬─────────┬──────────┬──────────────────┐ │
│  │Auth    │Dashboard│Task      │Project / Timesheet
│  │State   │State    │State     │Leave / Notif Mgmt│ │
│  └────────┴─────────┴──────────┴──────────────────┘ │
├─────────────────────────────────────────────────────┤
│              Repository / Service Layer              │
│  ┌──────────┬─────────┬────────┬──────────────────┐ │
│  │AuthSvc   │Dashboard│TaskSvc │ProjectSvc       │ │
│  │          │Service  │        │TimesheetSvc     │ │
│  │          │         │        │LeaveSvc         │ │
│  └──────────┴─────────┴────────┴──────────────────┘ │
├─────────────────────────────────────────────────────┤
│                  Core Layer                          │
│  ┌──────────────────────────────────────────────┐  │
│  │ MockApiService (Data Store)                  │  │
│  │ SecureStorage  │ LocalStorage  │ Theme      │  │
│  └──────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

#### 1.2 Module Boundaries & Communication

**8 Functional Modules** (within `lib/features/`):

1. **Authentication** (`lib/features/auth/`)
   - Handles login, remember me, session management
   - Interfaces: AuthService, session state provider/cubit
   - Cross-module contract: Exports authenticated user to global app state

2. **Dashboard** (`lib/features/dashboard/`)
   - Displays clock-in time, active hours, active task, quick actions
   - Interfaces: DashboardService (fetches summary), subscribes to active task state
   - Cross-module contract: Consumes active task from TaskService, subscribes to real-time timer

3. **Task Management** (`lib/features/task/`)
   - Create, read, start, pause, resume, complete tasks
   - Interfaces: TaskService, TaskStateNotifier (tracks active task)
   - Cross-module contract: Exports active task to Dashboard; timer state accessible to Notifications

4. **Project Management** (`lib/features/project/`)
   - Displays assigned projects, progress, team members, task breakdown
   - Interfaces: ProjectService (fetches project list, project details)
   - Cross-module contract: Task Management references project association

5. **Timesheet** (`lib/features/timesheet/`)
   - Calendar view, hour logging, submission, history
   - Interfaces: TimesheetService (log hours, submit, query history)
   - Cross-module contract: Consumes task history to populate timesheet

6. **Leave Management** (`lib/features/leave/`)
   - Leave application, balance tracking, approval status
   - Interfaces: LeaveService (apply, query balances, query approvals)
   - Cross-module contract: No hard dependencies; read-only on user profile

7. **Notifications** (`lib/features/notifications/`)
   - Receive, display, and route push/in-app notifications
   - Interfaces: NotificationService (subscribe, dismiss), FirebaseMessaging integration
   - Cross-module contract: Consumes task events (start, pause, complete) via event bus or stream

8. **Settings/Profile** (`lib/features/settings/`)
   - View and edit profile, configure preferences, logout
   - Interfaces: SettingsService (update profile, manage preferences, logout)
   - Cross-module contract: Logout action resets global authentication state

---

#### 1.3 Global Application State (Timer & User Context)

**Global Providers / Notifiers** (independent of module, managed at app level):

- **AuthUserProvider**: Authenticated user and session token (persists across navigation)
- **ActiveTaskProvider**: Currently running task (consumed by Dashboard and Notifications)
- **TimerProvider**: Real-time timer state for the active task
  - Device-driven updates (increment every 100ms)
  - Periodic validation checks against mock API
  - Pause/resume state
  - Offline reconciliation queued actions
- **ConnectivityProvider**: Online/offline status (drives timer reconciliation)
- **SyncQueueProvider**: Pending API calls awaiting reconnection

---

#### 1.4 Timer Architecture (Detailed)

**Real-Time Timer Implementation**:

```
User starts task at 10:00:00 AM
        ↓
TaskService.startTask(taskId)
        ↓
TimerProvider.startTimer(taskId, initialElapsed)
        ↓
Background isolate / async timer:
  - Increment elapsed every 100ms (device clock driven)
  - Update DashboardScreen in real-time (∆t < 1 second)
  - Queue periodic validation (every 30s):
    - Compare device elapsed vs. server elapsed
    - If divergence > threshold: adjust device timer
        ↓
Timeout / Manual stop:
  - Timer paused
  - Latest state persisted to local storage
  - TaskService.pauseTask(taskId, elapsedSeconds)
        ↓
On reconnect (if offline during pause):
  - Reconcile: device elapsed vs. server elapsed
  - If server has newer completion time, use server time
  - Send any queued stop/complete actions
```

**Offline Resilience**:
- Timer continues incrementing locally (device clock)
- No sync attempt until online
- On reconnect: sync queue processes (validate timer, send complete action if needed)
- User sees continuous timer updates through app lifetime

---

### 2. Component Breakdown by Feature Modules

---

#### **Module 1: Authentication** (`lib/features/auth/`)

**Directory Structure**:
```
lib/features/auth/
├── models/
│   ├── user.dart (User, UserProfile)
│   ├── login_request.dart (Email/password/OAuth)
│   └── session.dart (AuthToken, SessionStatus)
├── services/
│   ├── auth_service.dart (login, logout, refresh token, validate session)
│   ├── oauth_service.dart (Microsoft & Google OAuth flows)
│   └── secure_storage_service.dart (credential encryption/decryption)
├── state/
│   ├── auth_provider.dart (Riverpod/Bloc) - global authenticated user
│   └── session_cubit.dart (if using Bloc) - login/logout state machine
├── screens/
│   ├── login_screen.dart
│   ├── forgot_password_screen.dart
│   └── oauth_callback_handler.dart (deep link handling)
├── widgets/
│   ├── email_password_form.dart
│   ├── oauth_button.dart (Microsoft & Google)
│   ├── remember_me_checkbox.dart
│   └── loading_dialog.dart
└── test/
    ├── auth_service_test.dart
    ├── secure_storage_service_test.dart
    └── login_screen_test.dart
```

**Key Requirements Mapped**:
- FR-LOGIN-1: Email/password validation, login button disabled when empty
- FR-LOGIN-2: Error messages, loading indicator
- FR-LOGIN-3: "Remember Me" with encrypted storage
- FR-LOGIN-4: Forgot-password email reset flow
- FR-LOGIN-5: Microsoft & Google OAuth

**User Flows**:
1. **Happy Path**: Enter email → enter password → tap Login → loading → success → navigate to Dashboard
2. **Error Path**: Invalid credentials → show error message → remain on login screen
3. **Remember Me**: Check "Remember Me" → login → close app → reopen → email auto-filled
4. **OAuth**: Tap "Sign in with Google" → system browser flow → return to app → auto-create account
5. **Forgot Password**: Tap "Forgot Password" → enter email → show confirmation → email sent

**Test Strategy**:
- Unit: AuthService.login() with valid/invalid credentials, OAuth token validation
- Widget: Form validation (empty fields disable button), error message display
- Integration: Follow full login flow → Dashboard screen appears

**Integration Points**:
- AuthService exposes `Stream<AuthUser?>` for global user state subscription
- SessionToken exported to global app-level provider for downstream API authentication
- Logout triggers global state reset (clear active task, timer, cache)

---

#### **Module 2: Dashboard** (`lib/features/dashboard/`)

**Directory Structure**:
```
lib/features/dashboard/
├── models/
│   ├── dashboard_summary.dart (clockInTime, activeHours, totalTime, activeTask, status)
│   └── work_status.dart (online/offline indicator enum)
├── services/
│   ├── dashboard_service.dart (fetch summary, subscribe to real-time updates)
│   └── online_status_service.dart (track connection status)
├── state/
│   ├── dashboard_provider.dart (Riverpod) - summary state
│   ├── online_status_provider.dart - connectivity state
│   └── active_task_provider.dart - current task (consumed from TaskService)
├── screens/
│   └── dashboard_screen.dart (main layout, tab integration)
├── widgets/
│   ├── clock_in_card.dart (displays clock-in time + online status)
│   ├── active_hours_display.dart (real-time timer, HH:MM format)
│   ├── total_time_display.dart (HH:MM:SS format)
│   ├── active_task_card.dart (task name, ID, elapsed, billable, category, action buttons)
│   ├── quick_action_buttons.dart (Start/Pause/Resume/Complete)
│   └── task_status_indicator.dart (status badge: in-progress, paused, overdue)
└── test/
    ├── dashboard_service_test.dart
    ├── active_hours_display_test.dart
    └── dashboard_screen_test.dart
```

**Key Requirements Mapped**:
- FR-HOME-1: Clock-in time display (HH:MM)
- FR-HOME-2: Online/offline status (green/red indicator)
- FR-HOME-3: Real-time active hours (HH:MM, real-time updates)
- FR-HOME-4: Total time at work (HH:MM:SS)
- FR-HOME-5: Active task card (name, ID, elapsed, billable, category)
- FR-HOME-6: Quick-action buttons (start/pause/resume/complete)
- FR-HOME-7: Confirmation dialog before task completion
- FR-HOME-8: Auto-pause previous task when new task started

**User Flows**:
1. **Clock-In Status**: Employee opens app → Dashboard shows green "online" indicator + clock-in time
2. **Real-Time Timer**: Active hours increment every second in real-time (no refetch required)
3. **Start Task**: Tap "Start" on a task → previous task auto-pauses → confirmation notification → new task shows on dashboard
4. **Complete Task**: Tap "Complete" on active task → confirmation dialog → "Yes" → task moves to completed, timer stops

**Test Strategy**:
- Unit: DashboardService.fetchSummary(), time-formatting functions
- Widget: Timer increments every ~100ms; status indicators update based on connection state
- Integration: Start task from dashboard → active task state updates → Dashboard reflects change within 500ms

**Integration Points**:
- Consumes `ActiveTaskProvider` from TaskService
- Subscribes to `TimerProvider` for real-time updates
- Consumes `ConnectivityProvider` for online/offline status
- Publishes task actions (start, pause, complete) via TaskService

---

#### **Module 3: Task Management** (`lib/features/task/`)

**Directory Structure**:
```
lib/features/task/
├── models/
│   ├── task.dart (id, title, description, project, status, priority, estimated, elapsed, timestamps)
│   ├── task_status.dart (enum: NEW, IN_PROGRESS, OVERDUE, COMPLETED)
│   ├── priority.dart (enum: LOW, MEDIUM, HIGH)
│   ├── task_filter.dart (status-based filtering)
│   └── create_task_request.dart
├── services/
│   ├── task_service.dart (create, read, list, start, pause, resume, complete)
│   ├── timer_service.dart (persist timer state, load on app restart)
│   └── task_sync_service.dart (reconcile offline changes on reconnect)
├── state/
│   ├── task_list_provider.dart (Riverpod) - all tasks by status
│   ├── active_task_provider.dart - currently running task (exported to global)
│   ├── timer_notifier.dart - timer state machine (device clock driven)
│   └── task_sync_queue.dart - pending task actions awaiting sync
├── screens/
│   ├── task_list_screen.dart (tabbed: New, In Progress, Overdue, Completed)
│   ├── create_task_screen.dart
│   ├── task_detail_screen.dart
│   └── task_completion_dialog.dart
├── widgets/
│   ├── task_card.dart (task name, ID, elapsed, estimated, priority, category, status)
│   ├── task_status_badge.dart (New/In Progress/Overdue/Completed status)
│   ├── priority_indicator.dart (Low/Medium/High visual)
│   ├── timer_display.dart (elapsed time, reusable across screens)
│   ├── create_task_form.dart (title, project picker, estimated hours, priority, description)
│   ├── status_tab.dart (tab header with badge count)
│   ├── task_action_buttons.dart (Start/Pause/Resume/Complete)
│   └── overdue_warning.dart (red warning: overtime amount)
└── test/
    ├── task_service_test.dart
    ├── timer_notifier_test.dart
    ├── task_list_screen_test.dart
    └── create_task_screen_test.dart
```

**Key Requirements Mapped**:
- FR-TASK-1: Create task with title, project, estimated hours, priority, description
- FR-TASK-2: New task initialized with "New" status, success message
- FR-TASK-3: Task list tabs (New, In Progress, Overdue, Completed) with badge counts
- FR-TASK-4: Start task timer, status → "In Progress"
- FR-TASK-5: Single active task constraint (auto-pause previous)
- FR-TASK-6: Auto-change to "Overdue" when elapsed > estimated, red warning
- FR-TASK-7: Pause/resume buttons to control timer
- FR-TASK-8: Complete button with confirmation dialog + completion timestamp
- FR-TASK-9: Task sorting/filtering within tabs
- FR-TASK-10: Task details (elapsed, estimated, project, priority)

**User Flows**:
1. **Create Task**: Tap "Create" → fill form (title, project, estimated hours, priority) → submit → task appears in New tab with success message
2. **Start Task**: Tap "Start" on task card → confirm? Previous task pauses → task moves to In Progress tab → timer begins
3. **Overdue Transition**: Elapsed time exceeds estimated → task status auto-changes to Overdue → red background, warning "20 mins over"
4. **Complete Task**: Tap "Complete" → confirmation dialog → "Yes" → task moves to Completed tab → timer stops, timestamp recorded
5. **Pause/Resume**: Can pause active task without completing → status remains In Progress but timer frozen

**Test Strategy**:
- Unit: TaskService CRUD, timer increment logic, overdue detection (elapsed > estimated)
- Widget: Create form validation, status badge rendering, tab counts update
- Integration: Create task → appears in New tab; start task → moves to In Progress, Dashboard updates; auto-pause previous task; complete task → moves to Completed

**Integration Points**:
- TaskService exports `ActiveTaskProvider` (consumed by Dashboard, Notifications)
- TaskService exports `TimerProvider` (consumed by Dashboard for real-time display)
- Task actions published to `SyncQueueProvider` when offline
- On reconnect, `TaskSyncService` reconciles offline task changes (start/complete) with server

---

#### **Module 4: Project Management** (`lib/features/project/`)

**Directory Structure**:
```
lib/features/project/
├── models/
│   ├── project.dart (id, name, description, progress, startDate, endDate, teamMembers, taskCounts)
│   ├── project_progress.dart (percent, color-coding)
│   ├── team_member.dart (id, name, avatar, designation)
│   └── task_breakdown.dart (counts by status)
├── services/
│   └── project_service.dart (fetch project list, project detail, task breakdown)
├── state/
│   ├── project_list_provider.dart (Riverpod) - all assigned projects
│   └── project_detail_provider.dart - single project with full details + task breakdown
├── screens/
│   ├── project_list_screen.dart
│   └── project_detail_screen.dart
├── widgets/
│   ├── project_card.dart (name, progress bar, dates, team avatars, task counts)
│   ├── progress_bar.dart (0-100%, color-coded: green for on-track)
│   ├── date_range_display.dart (MMM DD, YYYY format, days remaining)
│   ├── team_avatars.dart (up to 4 avatars + "+X" indicator)
│   ├── task_breakdown_chart.dart (New/In Progress/Overdue/Completed counts)
│   └── days_remaining_badge.dart (with visual warning if overdue)
└── test/
    ├── project_service_test.dart
    └── project_list_screen_test.dart
```

**Key Requirements Mapped**:
- FR-PROJ-1: Project list (name, progress %, date range, team member count)
- FR-PROJ-2: Progress bar calculation (completed tasks / total tasks) with color coding
- FR-PROJ-3: Dates formatted "MMM DD, YYYY"; days remaining calculated; overdue warning
- FR-PROJ-4: Team avatars (up to 4) with "+X" indicator; tap to expand full team
- FR-PROJ-5: Total task count with breakdown by status
- FR-PROJ-6: Sorting projects by progress or dates

**User Flows**:
1. **View Project List**: Dashboard → tap Projects tab → list shows all assigned projects (name, progress, dates, avatars)
2. **View Project Detail**: Tap project card → detail screen shows full info: description, team members, task breakdown (New/In Progress/Overdue/Completed counts)
3. **Progress Calculation**: As tasks are completed, progress bar updates (e.g., 5 of 10 completed = 50%, green bar)
4. **Days Remaining**: Calculates days until project end date; shows red warning if overdue (negative days)

**Test Strategy**:
- Unit: Progress calculation, date formatting, days-remaining logic
- Widget: Project card rendering with progress bar, team avatars, status indicators
- Integration: Task completion updates project progress bar

**Integration Points**:
- Consumes task completion events from TaskService to recalculate progress
- ProjectService optionally exposes task breakdown that maps to Task Management module

---

#### **Module 5: Timesheet** (`lib/features/timesheet/`)

**Directory Structure**:
```
lib/features/timesheet/
├── models/
│   ├── timesheet_day.dart (date, hoursLogged, logEntries, submissionStatus, timestamp)
│   ├── log_entry.dart (date, startTime, endTime, hours, project, notes)
│   ├── timesheet_submission.dart (date, hoursSubmitted, status, timestamp)
│   ├── timesheet_history.dart (list of submissions, approval status)
│   ├── timesheet_totals.dart (loggedHours, submittedHours, diff, weeklyTotals, monthlyTotals)
│   └── submission_status.dart (enum: DRAFT, SUBMITTED, APPROVED, REJECTED)
├── services/
│   ├── timesheet_service.dart (log hours, submit, query history, calculate totals)
│   └── calendar_service.dart (fetch calendar view data, monthly navigation)
├── state/
│   ├── calendar_month_provider.dart (Riverpod) - current month view
│   ├── timesheet_history_provider.dart - submission history
│   └── timesheet_totals_provider.dart - calculated totals
├── screens/
│   ├── timesheet_screen.dart (main calendar view + month navigation)
│   ├── day_entry_screen.dart (log hours for selected date)
│   ├── submission_history_screen.dart (list of submitted timesheets)
│   ├── timesheet_totals_screen.dart (logged vs submitted vs difference)
│   └── submission_confirmation_dialog.dart
├── widgets/
│   ├── calendar_widget.dart (monthly view, hours per date, current day highlight, month nav)
│   ├── day_card.dart (date, hours logged, click to edit)
│   ├── time_range_picker.dart (select start/end time, calculate hours)
│   ├── project_picker.dart (link hours to project)
│   ├── submit_button.dart (with confirmation dialog)
│   ├── history_list.dart (submission dates, hours, approval status)
│   ├── totals_summary.dart (logged, submitted, difference, weekly/monthly breakdowns)
│   └── read_only_badge.dart (submitted timesheets marked "locked")
└── test/
    ├── timesheet_service_test.dart
    ├── calendar_widget_test.dart
    └── timesheet_screen_test.dart
```

**Key Requirements Mapped**:
- FR-TIME-1: Monthly calendar view with hours per date, current day highlighted, month navigation
- FR-TIME-2: Log hours with time range, project linkage, optional notes
- FR-TIME-3: Calendar updates when hours logged
- FR-TIME-4: Submit button with confirmation; locks timesheet read-only, records timestamp
- FR-TIME-5: Prevent editing of submitted timesheets
- FR-TIME-6: Display submission history (dates, hours, approval status)
- FR-TIME-7: Display totals (logged hours, submitted hours, difference)
- FR-TIME-8: Weekly and monthly hour totals

**User Flows**:
1. **View Calendar**: Tap Timesheet tab → calendar shows current month with hours logged per date
2. **Log Hours**: Tap date → day entry screen → set start/end times → select project → optional notes → save → calendar updates
3. **Submit**: Tap "Submit Timesheet" button → confirmation dialog → "Confirm" → locked as read-only, timestamp recorded
4. **View History**: Tap "History" → list shows past submissions (date, hours, approval status)
5. **View Totals**: Tap "Totals" → summary shows logged hours (e.g., "40:35"), submitted hours (e.g., "20:50"), difference, weekly/monthly breakdowns

**Test Strategy**:
- Unit: TimesheetService.logHours(), submit(), calculate totals
- Widget: Calendar rendering, day card display, time range picker, submit dialog
- Integration: Log hours → calendar updates; submit → locked state; history shows submission

**Integration Points**:
- Consumes task history from TaskService to auto-populate timesheet entries (optional pre-fill)
- TimesheetService publishes submission events that trigger notifications (FR-NOT-2, FR-NOT-3)

---

#### **Module 6: Leave Management** (`lib/features/leave/`)

**Directory Structure**:
```
lib/features/leave/
├── models/
│   ├── leave_application.dart (id, type, startDate, endDate, days, status, notes, timestamp)
│   ├── leave_type.dart (enum: VACATION, CASUAL, SICK, PARENTAL)
│   ├── leave_status.dart (enum: PENDING, APPROVED, REJECTED)
│   ├── leave_balance.dart (type, available, booked, annual, allocation, expiry)
│   ├── approved_leave.dart (dates, days, type, cancelOption)
│   └── leave_entitlement.dart (type, allocation, expiryDate, carryOver)
├── services/
│   ├── leave_service.dart (apply, query balances, query applications, query approvals, calculate days)
│   └── leave_validation_service.dart (check overlap, insufficient balance, past dates)
├── state/
│   ├── leave_application_list_provider.dart (Riverpod) - pending/approved/rejected applications
│   ├── leave_balance_provider.dart - available balance by type
│   └── approved_leave_provider.dart - booked leave periods
├── screens/
│   ├── leave_screen.dart (main view: apply / view balance / view approvals)
│   ├── leave_application_screen.dart (form: date range, leave type, notes)
│   ├── leave_balance_screen.dart (breakdown by type with entitlements)
│   └── approved_leave_screen.dart (list of booked leave with cancellation option)
├── widgets/
│   ├── date_range_picker.dart (select start/end, block past/already-booked dates)
│   ├── leave_type_dropdown.dart (list: Vacation, Casual, Sick, Parental + balance)
│   ├── application_status_badge.dart (Pending/orange, Approved/green, Rejected/red)
│   ├── balance_card.dart (type, available, booked, annual, allocation, expiry)
│   ├── application_form.dart (date range, type, notes, submit)
│   ├── approved_leave_card.dart (dates, days, type, cancellation button)
│   └── balance_summary.dart (total available, booked, annual with breakdown)
└── test/
    ├── leave_service_test.dart
    ├── leave_validation_service_test.dart
    └── leave_application_screen_test.dart
```

**Key Requirements Mapped**:
- FR-LEAVE-1: Application form (date range picker with validation, leave type, notes)
- FR-LEAVE-2: Leave balance displayed for each type in dropdown
- FR-LEAVE-3: Days calculated from date range
- FR-LEAVE-4: Application status (Pending/orange, Approved/green, Rejected/red)
- FR-LEAVE-5: Available days, booked days, annual balance with breakdown
- FR-LEAVE-6: Annual entitlement with allocation date, expiry date, carry-over
- FR-LEAVE-7: Approved leave periods with dates, days, type, cancellation option

**User Flows**:
1. **Apply for Leave**: Tap Leave tab → "New Application" → select date range → choose leave type (shows balance) → optional notes → submit
2. **Check Balance**: Tap "Balances" → card per leave type showing available, booked, annual, allocation date, expiry date
3. **View Approvals**: Tap "My Leaves" → list of all applications (status badges indicate Pending/Approved/Rejected)
4. **Approved Leave**: List of approved leave periods with cancellation button where allowed

**Test Strategy**:
- Unit: Date validation (no past dates, no overlaps, sufficient balance), days calculation
- Widget: Date picker with blocked dates, leave type dropdown with balance display, status badges
- Integration: Apply for leave → appears in "My Leaves" with Pending status; receive approval notification → status updates to Approved

**Integration Points**:
- LeaveService publishes application events that trigger notifications (FR-NOT-3)
- Leave balance state may be read by Timesheet to check availability before approval/rejection processing

---

#### **Module 7: Notifications** (`lib/features/notifications/`)

**Directory Structure**:
```
lib/features/notifications/
├── models/
│   ├── notification.dart (id, userId, type, title, message, relatedEntity, read, timestamp)
│   ├── notification_type.dart (enum: TASK_START, TASK_PAUSE, TASK_COMPLETE, TIMESHEET_REMINDER, LEAVE_APPROVED, LEAVE_REJECTED)
│   ├── notification_payload.dart (type-specific data: task name, elapsed time, leave type, etc.)
│   └── notification_preference.dart (appEnabled, pushEnabled, soundEnabled, quietHours)
├── services/
│   ├── notification_service.dart (subscribe to notifications, dismiss, query history)
│   ├── firebase_notification_handler.dart (handle FCM payload, route to appropriate screen)
│   └── notification_preference_service.dart (manage user preferences)
├── state/
│   ├── notification_stream_provider.dart (Riverpod) - live notification stream
│   ├── notification_history_provider.dart - past notifications
│   └── notification_preferences_provider.dart - user preferences
├── screens/
│   └── notification_history_screen.dart (list of all notifications, mark as read)
├── widgets/
│   ├── notification_item.dart (title, message, timestamp, tap-to-navigate)
│   ├── in_app_notification_overlay.dart (toast-style display for active app)
│   ├── task_event_notification.dart (task name, event type, elapsed time)
│   ├── leave_status_notification.dart (leave type, status, dates)
│   └── timesheet_reminder_notification.dart (pending hours, tap-to-open timesheet)
└── test/
    ├── firebase_notification_handler_test.dart
    └── notification_service_test.dart
```

**Key Requirements Mapped**:
- FR-NOT-1: Push & in-app notifications for task events (start, pause, complete)
- FR-NOT-2: End-of-day timesheet reminder (show pending hours, tap to open timesheet)
- FR-NOT-3: Leave submission confirmation and status change notifications
- FR-NOT-4: Notification dismissal and history
- FR-NOT-5: Notification preferences (app/push toggle, sound, quiet hours)

**User Flows**:
1. **Task Event Notification**: Employee starts task → push notification fires (async, if app backgrounded) → in-app notification displays → tap → navigates to dashboard
2. **Timesheet Reminder**: End of day (5:30 PM) → notification shows "2 hours pending" → tap → opens Timesheet screen
3. **Leave Status Notification**: Leave application processed → notification "Leave Approved for Mar 17-18" → tap → opens Leave screen
4. **Notification Preferences**: Settings → Notifications → toggle "App Notifications" on/off, enable/disable sound, set quiet hours (e.g., 6 PM – 8 AM)

**Test Strategy**:
- Unit: Notification routing logic (which screen to navigate to based on type)
- Widget: In-app notification overlay display, history list rendering
- Integration: Task event triggers notification; tap notification routes to correct screen

**Integration Points**:
- Consumes task events (start, pause, complete) from TaskService via event stream or callback
- Consumes timesheet submission reminders (time-of-day trigger)
- Consumes leave status changes from LeaveService
- Integrates with FirebaseMessaging for push delivery (FCM tokens, payload handling)
- Integrates with platform notification services (APNs for iOS, notification channels for Android)

---

#### **Module 8: Settings/Profile** (`lib/features/settings/`)

**Directory Structure**:
```
lib/features/settings/
├── models/
│   ├── user_profile.dart (name, email, employeeId, department, designation, picture)
│   ├── profile_update_request.dart (name, phone, password)
│   ├── notification_preferences.dart (app enabled, push enabled, sound, quiet hours)
│   └── private_time.dart (enabled, duration, remainingSeconds)
├── services/
│   ├── settings_service.dart (update profile, manage preferences, logout)
│   ├── profile_picture_service.dart (fetch, upload)
│   └── private_time_service.dart (start countdown, pause active task, notify on end)
├── state/
│   ├── user_profile_provider.dart (Riverpod) - user profile info
│   ├── notification_preferences_provider.dart - notification settings
│   └── private_time_provider.dart - private time state (countdown)
├── screens/
│   ├── settings_screen.dart (navigation hub: profile, preferences, private time, logout)
│   ├── profile_edit_screen.dart (edit name, phone, password)
│   ├── notification_preferences_screen.dart (toggles for app/push/sound, quiet hours)
│   ├── private_time_screen.dart (enable, select duration, countdown display)
│   └── logout_confirmation_dialog.dart
├── widgets/
│   ├── profile_section.dart (view: name, email, employee ID, department, designation, picture)
│   ├── profile_edit_form.dart (editable name, phone, password fields with validation)
│   ├── password_field.dart (password input with visibility toggle)
│   ├── notification_preference_toggle.dart (app/push/sound toggles)
│   ├── quiet_hours_picker.dart (time range picker)
│   ├── private_time_control.dart (duration picker: 15 min / 30 min / custom)
│   ├── private_time_countdown.dart (displays remaining time)
│   └── logout_options_dialog.dart (current device / all devices)
└── test/
    ├── settings_service_test.dart
    ├── profile_edit_screen_test.dart
    └── private_time_service_test.dart
```

**Key Requirements Mapped**:
- FR-SET-1: Display account info (name, email, employee ID, department, designation, picture)
- FR-SET-2: Update name, phone, password with validation and success message
- FR-SET-3: Private time toggle (duration: 15 min / 30 min / custom), pauses active task, countdown, notification on end
- FR-SET-4: Logout with confirmation (current device / all devices), clears session and cache
- FR-SET-5: Notification preferences (app/push/sound toggles, quiet hours)

**User Flows**:
1. **View Profile**: Tap Settings tab → "Profile" section shows name, email, employee ID, department, designation, picture
2. **Edit Profile**: Tap "Edit" → form allows updating name, phone, password (with validation) → save → success message → profile refreshes
3. **Private Time**: Tap "Private Time" → toggle enabled → select duration (15 min / 30 min / custom) → countdown starts → active task pauses → notification fires when time ends
4. **Notification Preferences**: Tap "Notifications" → toggles for app notifications, push notifications, sound → optional quiet hours (e.g., 6 PM – 8 AM)
5. **Logout**: Tap "Logout" → confirmation dialog with options ("Current Device" or "All Devices") → clear session & cache → navigate to Login screen

**Test Strategy**:
- Unit: Password validation (min length, complexity), private time countdown logic, logout session clearing
- Widget: Profile form with inline validation, notification preference toggles, private time duration picker
- Integration: Edit profile → changes persist and appear on next screen refresh; logout → session cleared, redirected to login

**Integration Points**:
- SettingsService publishes logout event that resets global AuthUserProvider and ActiveTaskProvider
- PrivateTimeService pauses ActiveTaskProvider when countdown starts
- Notification preferences stored persistently via NotificationPreferenceService

---

### 3. Data Flow & State Management Strategy

#### 3.1 Global State Architecture

The app manages the following **global state** (independent of modules, accessible app-wide):

```
Global State Scope:
┌──────────────────────────────────────┐
│        Application-Level State       │
├──────────────────────────────────────┤
│ • AuthUserProvider → User & session  │
│ • ActiveTaskProvider → Current task  │
│ • TimerProvider → Real-time timer    │
│ • ConnectivityProvider → Online/off  │
│ • SyncQueueProvider → Pending actions│
└──────────────────────────────────────┘
        ↓         ↓         ↓
┌────────────┬──────────────┬──────────────┐
│  Dashboard │ Notifications│    Task      │
│  (consume) │   (consume)  │  (consume)   │
└────────────┴──────────────┴──────────────┘
```

**AuthUserProvider**:
- Type: `Riverpod FutureProvider<User?>` or `Bloc AuthCubit<User?>`
- Scope: App-level (managed by AuthService)
- Persisted: Yes (encrypted secure storage via "Remember Me")
- Consumed by: All modules (dependency injection); triggers conditional navigation (login vs. dashboard)
- Updated by: LoginService.login(), LogoutService.logout()

**ActiveTaskProvider**:
- Type: `Riverpod StateNotifier<Task?>` or `Bloc TaskCubit<Task?>`
- Scope: App-level (managed by TaskService)
- Persisted: No (in-memory only; restored on app launch if timer was running)
- Consumed by: Dashboard (displays active task), Notifications (triggers task event notifications)
- Updated by: TaskService.startTask(), TaskService.pauseTask(), TaskService.completeTask()

**TimerProvider**:
- Type: `Riverpod StateNotifier<TimerState>` or custom `TimerNotifier`
- Scope: App-level (managed by TimerService)
- Persisted: Yes (to local storage on pause/background; restored on app launch)
- Consumed by: Dashboard (real-time display), NotificationService (elapsed time in notifications)
- Updated by: Device clock tick (every 100ms), periodic server validation (every 30s)
- Structure:
  ```dart
  class TimerState {
    final String activeTaskId;
    final int elapsedSeconds;        // device-driven
    final TimerStatus status;        // running, paused, completed
    final DateTime lastSyncTime;     // last server validation
    final int serverElapsedSeconds;  // last known server value
  }
  ```

**ConnectivityProvider**:
- Type: `Riverpod FutureProvider<bool>` (true = online, false = offline)
- Scope: App-level
- Persisted: No (determined at runtime)
- Consumed by: Dashboard (status indicator), SyncService (triggers reconciliation on reconnect)
- Updated by: Connectivity plugin checks

**SyncQueueProvider**:
- Type: `Riverpod StateNotifier<List<SyncAction>>`
- Scope: App-level
- Persisted: Yes (to local storage; retry on reconnect)
- Consumed by: SyncService (processes queue on online transition)
- Updated by: TaskService (queues start/pause/complete), TimesheetService (queues submissions), LeaveService (queues applications)
- Structure:
  ```dart
  class SyncAction {
    final String type;      // "task_start", "task_complete", "timesheet_submit"
    final String entityId;
    final DateTime timestamp;
    final Map<String, dynamic> payload;
  }
  ```

---

#### 3.2 Module-Level State

Each module maintains its own state (scoped to that module's domain):

| Module | Primary State | Type | Persistence |
|--------|---------------|------|-------------|
| Auth | AuthUser, SessionToken | FutureProvider / Cubit | Encrypted secure storage |
| Dashboard | Summary (clockIn, active hours, totals) | FutureProvider | In-memory only |
| Task | Task list (by status), task detail | StateNotifier / Cubit | In-memory (sync queue for offline) |
| Project | Project list, project detail | FutureProvider | In-memory only |
| Timesheet | Calendar state, submission history | FutureProvider / StateNotifier | In-memory (submissions persisted on sync) |
| Leave | Applications, balances, approvals | FutureProvider | In-memory only |
| Notifications | Notification list, preferences | StateNotifier | Preferences persisted in SharedPreferences |
| Settings | User profile, preferences | FutureProvider / StateNotifier | Profile in encrypted storage, preferences in SharedPreferences |

---

#### 3.3 Data Flow Diagrams

**Flow 1: User Logs In**
```
LoginScreen → AuthService.login(email, pwd)
  → Mock API: validate credentials in in-memory user table
    → If valid: return User { id, name, email, token }
    → If invalid: throw LoginException
  → (on success) SecureStorageService.saveCredentials()
  → AuthUserProvider updated (notify all listeners)
  → DashboardScreen rendered
```

**Flow 2: Employee Starts Task**
```
DashboardScreen → TaskService.startTask(taskId)
  ↓
1. Check if another task is active
   yes? → TaskService.pauseTask(previousTaskId)
        → ActiveTaskProvider updated
        → Dashboard updates (previous task paused)
        → Notification fired: "Task X paused"
   ↓
2. TaskService.startTask(taskId)
   → Update task status to IN_PROGRESS
   → TimerProvider initialized with startTime, elapsedSeconds=0
   → TimerService starts device clock-driven increment (every 100ms)
   → Dashboard real-time updates begin
   ↓
3. Mock API: Queue "task_start" action to SyncQueueProvider
   (actual API call: POST /task/{id}/start)
   ↓
4. Notification: "Task X started at HH:MM"
```

**Flow 3: App Backgrounded → Resumed (Offline Timer Persistence)**
```
App Running:
  Active task timer at 00:15:30 (15 mins 30 secs elapsed)
  ↓
User presses home button (app backgrounded)
  → WidgetsBinding.instance.addObserver(LifecycleEventHandler)
  → onPause() triggered
  → TimerService.pauseTimer() (freeze timer state)
  → LocalStorageService.saveTimerState() to encrypted file:
     {
       activeTaskId: "123",
       elapsedSeconds: 930,
       pausedAt: 2026-03-13T10:15:30Z,
       status: "paused_by_background"
     }
  ↓
User force-closes app or device restarts
  ↓
App Relaunched:
  → WidgetsBinding.instance.addObserver(LifecycleEventHandler)
  → onResume() triggered
  → TimerService.restoreTimerState() from local storage
  → If active task found: restore to ActiveTaskProvider
  → Resume device clock-driven increment
  → Dashboard shows timer continuing from saved elapsed time
  ↓
On next sync (connectivity restored or manual trigger):
  → SyncService.reconcileTimer()
  → Compare device elapsed (930s) vs. server elapsed (if available)
  → If divergence < 5s: accept device time
  → If divergence ≥ 5s: adjust device timer to server time (show reconciliation notification)
```

**Flow 4: Task Completion (with Offline Handling)**
```
DashboardScreen → (tap "Complete")
  ↓ Confirmation dialog → "Yes"
  ↓
TaskService.completeTask(taskId)
  → TimerProvider stopped (freeze)
  → Task status updated to COMPLETED
  → Completion timestamp recorded
  → Last elapsed time saved (e.g., 01:23:45)
  ↓
If online:
  → Mock API: POST /task/{id}/complete { elapsedSeconds, completedAt }
  → (success) Task removed from ActiveTaskProvider
  → Dashboard clears active task card
  → Notification: "Task X completed in 01:23:45"
  ↓
If offline:
  → Queue "task_complete" action to SyncQueueProvider
  → LocalStorageService.saveTaskForSync()
  → Show user: "Task saved (will sync when online)"
  → On reconnect: SyncService processes queue, sends completion to API
```

**Flow 5: Timesheet Submission**
```
TimesheetScreen → (user enters hours for day, project link, notes)
  → LocalStorageService caches log entry (in-memory or local file)
  → CalendarWidget updates to show hours on date
  ↓
User taps "Submit Timesheet"
  → SubmissionConfirmationDialog appears
  → User confirms
  ↓
TimesheetService.submitTimesheet()
  ↓
If online:
  → Mock API: POST /timesheet/submit { dayEntries[], submissionDatetime }
  → (success) LocalStorageService.clearDrafts()
  → TimesheetProvider updated: status = SUBMITTED
  → CalendarWidget shows locks on submitted dates
  → Notification: "Timesheet submitted (XX hours)"
  ↓
If offline:
  → Queue "timesheet_submit" action to SyncQueueProvider
  → Pessimistic update (mark as SUBMITTED locally)
  → On reconnect: SyncService sends to API, reconciles response
```

---

#### 3.4 Offline-First Sync Strategy

**Sync Queue** (managed by SyncQueueProvider):

```dart
class SyncTask {
  final String id;              // unique ID per sync task
  final SyncAction action;      // task_start, task_complete, timesheet_submit, leave_apply
  final Map<String, dynamic> payload;
  final int retryCount;
  final DateTime createdAt;
}
```

**Sync Lifecycle**:

1. **Action Queued** (offline)
   - TaskService.startTask() queues SyncAction to SyncQueueProvider
   - Action persisted to encrypted local storage (survives app restart)

2. **Online Detected**
   - ConnectivityProvider transitions to online
   - SyncService listener triggered
   - SyncService.processSyncQueue() begins

3. **Queue Processing**
   - Iterate through all SyncActions in priority order
   - For each action:
     - Attempt to send to mock API (or real backend)
     - If success: remove from queue
     - If failure (network error): retry up to 3 times with exponential backoff
     - If critical error (e.g., 401 Unauthorized): purge action, log error, alert user

4. **Timer Reconciliation**
   - After queue flush: TimerService.reconcileTimerWithServer()
   - Compare device elapsed vs. server elapsed
   - If divergence: adjust device timer (silent if < threshold, notify if > threshold)

5. **Retry Policy**
   - Exponential backoff: 1s, 2s, 4s (max 3 retries)
   - Failed syncs stored for manual retry via "Retry Failed Syncs" button in Settings
   - No data loss: all queued actions retained until explicitly removed

---

### 4. Navigation Structure

#### 4.1 Bottom Tab Navigation (5-6 Primary Tabs)

The app uses **bottom tab navigation** with 5–6 main tabs. Each tab represents a primary feature module:

```
┌─────────────────────────────────────────────────────┐
│                    App Header                       │
├─────────────────────────────────────────────────────┤
│                Tab Content (Screen)                 │
│                                                     │
│  (content varies by selected tab)                   │
├─────────────────────────────────────────────────────┤
│  🏠  📋  ⏱️  📊  🗓️  ⚙️                             │
│ Dashboard Tasks Timesheet Projects Leave  Settings  │
└─────────────────────────────────────────────────────┘
```

**Tabs (in order, left to right)**:

1. **Dashboard** (`/dashboard`)
   - Icon: Home 🏠
   - Content: Clock-in status, active hours, total time, active task card, quick actions
   - Badge: None (or notification count if unread notifications)

2. **Tasks** (`/tasks`)
   - Icon: List 📋
   - Content: Task list (tabbed: New, In Progress, Overdue, Completed)
   - Badge: Count of In Progress + Overdue tasks

3. **Timesheet** (`/timesheet`)
   - Icon: Calendar ⏱️
   - Content: Monthly calendar, submit button, history, totals
   - Badge: Days with unsubmitted hours

4. **Projects** (`/projects`)
   - Icon: Chart 📊
   - Content: Assigned projects list (with progress, dates, team)
   - Badge: None (or count of overdue projects)

5. **Leave** (`/leave`)
   - Icon: Tree 🗓️
   - Content: Apply for leave, view balance, view approvals
   - Badge: Count of pending leave approvals

6. **Settings** (`/settings`)
   - Icon: Gear ⚙️
   - Content: Profile, notification preferences, private time, logout
   - Badge: None

---

#### 4.2 Navigation Graph (with Nesting)

```
App Navigator
├── Auth Stack
│   ├── LoginScreen
│   └── ForgotPasswordScreen
└── Main Stack (after login)
    ├── BottomTabNavigator
    │   ├── Dashboard Tab
    │   │   └── DashboardScreen
    │   ├── Tasks Tab
    │   │   ├── TaskListScreen
    │   │   ├── CreateTaskScreen (modal)
    │   │   └── TaskDetailScreen (secondary route)
    │   ├── Timesheet Tab
    │   │   ├── TimesheetScreen
    │   │   ├── DayEntryScreen (modal)
    │   │   ├── SubmissionHistoryScreen (secondary)
    │   │   └── TotalsScreen (secondary)
    │   ├── Projects Tab
    │   │   ├── ProjectListScreen
    │   │   └── ProjectDetailScreen (secondary route)
    │   ├── Leave Tab
    │   │   ├── LeaveScreen
    │   │   ├── LeaveApplicationScreen (modal)
    │   │   └── LeaveBalanceScreen (secondary)
    │   └── Settings Tab
    │       ├── SettingsScreen
    │       ├── ProfileEditScreen (modal)
    │       └── NotificationPreferencesScreen (modal)
    └── Logout → Auth Stack (LoginScreen)
```

**Navigation Rules**:

- **Tab persistence**: Tapping a tab navigates to that tab's root screen. Navigating within a tab (e.g., TaskListScreen → TaskDetailScreen) does not change the tab context; returning pops the nested navigation stack first.
- **Modal screens**: Create, edit, and detailed views open as modals (full-screen or bottom sheet) on top of current tab without changing active tab.
- **Deep linking**: Notification taps can deep-link to any screen (e.g., "task complete notification" → DashboardScreen → TaskDetailScreen for the completed task).
- **Logout**: Logout clears the entire Main Stack and returns to Auth Stack (LoginScreen).

---

#### 4.3 Implementation Example (Riverpod + go_router)

```dart
// Pseudo-code: Navigation setup

final routerProvider = Provider((ref) {
  final authUser = ref.watch(authUserProvider);

  return GoRouter(
    redirect: (context, state) {
      // Redirect to login if not authenticated
      if (authUser == null && !isLoginRoute(state.location)) {
        return '/login';
      }
      if (authUser != null && state.location == '/login') {
        return '/dashboard'; // redirect login to dashboard
      }
      return null; // no redirect
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TaskListScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const CreateTaskScreen(),
          ),
          GoRoute(
            path: ':taskId',
            builder: (context, state) {
              final taskId = state.pathParameters['taskId']!;
              return TaskDetailScreen(taskId: taskId);
            },
          ),
        ],
      ),
      // ... (similar for Timesheet, Projects, Leave, Settings tabs)
    ],
  );
});
```

---

### 5. Integration Points with Mock API Service

The app integrates with the existing **MockApiService** at [`lib/core/network/mock/mock_api_service.dart`](lib/core/network/mock/mock_api_service.dart) for all backend communication.

#### 5.1 MockApiService Interface Overview

```dart
class MockApiService {
  // Authentication
  Future<LoginResponse> login(String email, String password) async { ... }
  Future<OAuthTokenResponse> exchangeOAuthCode(String provider, String code, String codeVerifier) async { ... }
  Future<void> logout(String sessionToken) async { ... }
  Future<UserProfile> getUserProfile(String sessionToken) async { ... }

  // Task Management
  Future<List<Task>> listTasks(String sessionToken, {TaskStatus? status}) async { ... }
  Future<Task> createTask(String sessionToken, CreateTaskRequest request) async { ... }
  Future<Task> getTask(String sessionToken, String taskId) async { ... }
  Future<void> startTask(String sessionToken, String taskId) async { ... }
  Future<void> pauseTask(String sessionToken, String taskId, int elapsedSeconds) async { ... }
  Future<void> completeTask(String sessionToken, String taskId, int elapsedSeconds) async { ... }

  // Project Management
  Future<List<Project>> listProjects(String sessionToken) async { ... }
  Future<Project> getProjectDetail(String sessionToken, String projectId) async { ... }

  // Timesheet
  Future<void> logHours(String sessionToken, TimeLogEntry entry) async { ... }
  Future<void> submitTimesheet(String sessionToken, List<TimeLogEntry> entries, DateTime submittedAt) async { ... }
  Future<List<TimesheetSubmission>> getTimesheetHistory(String sessionToken) async { ... }

  // Leave Management
  Future<LeaveApplication> applyLeave(String sessionToken, LeaveApplicationRequest request) async { ... }
  Future<List<LeaveApplication>> getLeaveApplications(String sessionToken) async { ... }
  Future<LeaveBalance> getLeaveBalance(String sessionToken, LeaveType type) async { ... }

  // Notifications
  Future<void> registerPushToken(String sessionToken, String token, String platform) async { ... }

  // Timer Validation
  Future<TimerValidationResponse> validateTimer(String sessionToken, String taskId, int deviceElapsed) async { ... }
}
```

#### 5.2 Mock Data Structure

The MockApiService maintains in-memory data structures (can be persisted to local storage for multi-session testing):

```dart
// lib/core/network/mock/mock_data.dart

const mockUsers = [
  User(
    id: 'emp-001',
    email: 'alice@company.com',
    password: 'password123', // hardcoded for MVP
    name: 'Alice Johnson',
    employeeId: 'EMP-001',
    department: 'Engineering',
    designation: 'Senior Engineer',
    profilePicture: 'https://...',
  ),
  // ... more users
];

const mockProjects = [
  Project(
    id: 'proj-001',
    name: 'Mobile App 2024',
    startDate: '2026-01-15',
    endDate: '2026-06-30',
    teamMembers: [...],
  ),
  // ... more projects
];

const mockLeaveTypes = [
  LeaveType(id: 'vacation', name: 'Vacation', balance: 15),
  LeaveType(id: 'casual', name: 'Casual', balance: 10),
  LeaveType(id: 'sick', name: 'Sick', balance: 5),
  LeaveType(id: 'parental', name: 'Parental', balance: 90),
];
```

#### 5.3 Integration Workflow

**Example: Task Start Flow**

```dart
// lib/features/task/services/task_service.dart

class TaskService {
  static const _logger = Logger('TaskService');
  final MockApiService _api;
  final _activeTaskNotifier = StateNotifier<Task?>(null);

  Future<void> startTask(String taskId) async {
    try {
      _logger.info('Starting task: $taskId');

      // 1. Optimistic update:
      final parentTask = _taskListNotifier.state.value?.firstWhere((t) => t.id == taskId);
      if (parentTask != null) {
        final updatedTask = parentTask.copyWith(
          status: TaskStatus.inProgress,
          startTime: DateTime.now(),
        );
        _activeTaskNotifier.state = updatedTask;
      }

      // 2. Fetch current session token
      final sessionToken = _authProvider.state.value?.sessionToken ?? '';

      // 3. Call mock API
      await _api.startTask(sessionToken, taskId);

      // 4. Refresh full task list to ensure consistency
      await _refreshTaskList();

      // 5. Queue for sync (in case offline)
      _syncQueueProvider.state.add(
        SyncAction(
          type: 'task_start',
          entityId: taskId,
          timestamp: DateTime.now(),
          payload: {'taskId': taskId},
        ),
      );

      _logger.info('Task started successfully: $taskId');
    } on Exception catch (e) {
      _logger.severe('Failed to start task: $e');
      // Revert optimistic update
      _activeTaskNotifier.state = null;
      rethrow;
    }
  }
}
```

#### 5.4 API Endpoint Mapping

| Feature | Method | Endpoint | Request | Response |
|---------|--------|----------|---------|----------|
| **Auth** | POST | `/auth/login` | `{ email, password }` | `{ userId, token, user }` |
| | POST | `/auth/oauth/callback` | `{ provider, code, codeVerifier }` | `{ token, user }` |
| | GET | `/auth/profile` | Header: `Authorization: Bearer {token}` | `{ user }` |
| | POST | `/auth/logout` | Header: `Authorization: Bearer {token}` | `{ success }` |
| **Task** | GET | `/tasks` | Query: `status=IN_PROGRESS` (optional) | `{ tasks: [] }` |
| | POST | `/tasks` | `{ title, projectId, estimatedHours, priority, description }` | `{ task }` |
| | POST | `/tasks/{id}/start` | `{}` | `{ task }` |
| | POST | `/tasks/{id}/pause` | `{ elapsedSeconds }` | `{ task }` |
| | POST | `/tasks/{id}/complete` | `{ elapsedSeconds }` | `{ task }` |
| **Project** | GET | `/projects` | — | `{ projects: [] }` |
| | GET | `/projects/{id}` | — | `{ project }` |
| **Timesheet** | POST | `/timesheet/log` | `{ date, startTime, endTime, projectId, notes }` | `{ logEntry }` |
| | POST | `/timesheet/submit` | `{ entries: [], submittedAt }` | `{ submission }` |
| | GET | `/timesheet/history` | — | `{ submissions: [] }` |
| **Leave** | POST | `/leave/apply` | `{ type, startDate, endDate, notes }` | `{ application }` |
| | GET | `/leave/applications` | — | `{ applications: [] }` |
| | GET | `/leave/balance/{type}` | — | `{ balance }` |
| **Notifications** | POST | `/notifications/register` | `{ pushToken, platform }` | `{ success }` |
| **Timer** | POST | `/tasks/{id}/validate` | `{ deviceElapsed }` | `{ serverElapsed, divergence }` |

---

### 6. Testing Strategy

#### 6.1 Test Pyramid

```
        /\
       /  \  End-to-End (E2E)
      /────\ - Full app flows: login → task start → complete → logout
     /      \ - Platform-specific (Android, iOS)
    /────────\
   /          \ Integration Tests
  /  ──────── \ - Module cross-talk: Task start → Dashboard update → Notification
 /            \ - API sync queue: offline task → cached → online → synced
/──────────────\
  Unit Tests
  - TaskService, TimerProvider, models, formatters
  - Each module's service & state logic
```

#### 6.2 Test Structure

```
test/
├── features/
│   ├── auth/
│   │   ├── services_test.dart
│   │   ├── screens_test.dart (widget tests)
│   │   └── integration_test.dart
│   ├── task/
│   │   ├── services_test.dart (TaskService unit tests)
│   │   ├── timer_notifier_test.dart (timer state machine)
│   │   ├── screens_test.dart (widget tests for TaskListScreen, CreateTaskScreen)
│   │   └── integration_test.dart (full task lifecycle)
│   ├── dashboard/
│   │   ├── services_test.dart
│   │   ├── screens_test.dart
│   │   └── integration_test.dart (dashboard updates on task start)
│   ├── timesheet/
│   │   ├── services_test.dart
│   │   ├── screens_test.dart
│   │   └── integration_test.dart
│   ├── project/
│   │   ├── services_test.dart
│   │   └── screens_test.dart
│   ├── leave/
│   │   ├── services_test.dart
│   │   └── screens_test.dart
│   ├── notifications/
│   │   ├── services_test.dart
│   │   └── integration_test.dart
│   └── settings/
│       ├── services_test.dart
│       └── screens_test.dart
├── core/
│   ├── network/
│   │   ├── mock_api_service_test.dart (mock API behavior)
│   │   └── api_interceptor_test.dart (auth header injection)
│   ├── storage/
│   │   └── secure_storage_service_test.dart
│   └── theme/
│       └── theme_test.dart (color, typography consistency)
└── integration_test/
    ├── login_flow_test.dart (E2E)
    ├── task_workflow_test.dart (E2E)
    ├── offline_sync_test.dart (E2E)
    └── timer_persistence_test.dart (E2E: force-close, resume, server sync)
```

#### 6.3 Coverage Goals

- **Business Logic** (models, services, notifiers): ≥ 80% line coverage
- **Widget Tests**: All core UI screens exercised (at least happy path)
- **Integration Tests**: Full user workflows (login, task start/complete, timesheet submit, logout)
- **Platform-Specific**: Android, iOS emulator smoke tests before release

---

## Phase 2: Implementation Roadmap (Phased Delivery)

### Release Cadence: Bi-weekly sprints

**Sprint 1–2 (Weeks 1–2): Foundation & Auth**
- Auth module complete (email/password, OAuth stubs, remember me)
- Core network & storage infrastructure
- Theme & design tokens established
- Dashboard screen layout (no data fetching yet)

**Sprint 3–4 (Weeks 3–4): Core Workflows**
- Task management module (create, list, start, pause, complete)
- Real-time timer implementation & persistence
- Dashboard integration (display active task, real-time timer)
- Offline sync queue infrastructure

**Sprint 5–6 (Weeks 5–6): Secondary Features**
- Timesheet calendar & submission
- Project list & detail screens
- Leave application & balance tracking
- Notifications infrastructure (local + Firebase setup)

**Sprint 7–8 (Weeks 7–8): Polish & Testing**
- Settings & profile management
- Notifications full integration (task events, reminders, leave updates)
- Private time feature
- Cross-platform testing (Android, iOS, Web, desktop smoke tests)
- Performance optimization (low-end device testing)
- Accessibility audit (WCAG 2.1 AA compliance)

**Sprint 9+ (Weeks 9–): Hardening & Production**
- Bug fixes & regression testing
- Security audit (encryption, OAuth, token management)
- Load testing (100+ active tasks)
- Production deployment & monitoring setup

---

## Success Criteria & Metrics

| Metric | Target | Validation |
|--------|--------|-----------|
| **SC-001**: Login completion time | <15 seconds | Timed device test; any auth method |
| **SC-002**: Dashboard real-time update | <1 second latency | Timer increments visible within 1s of app focus |
| **SC-003**: First-task creation | 95% success @ <2 mins | User study or analytics tracking |
| **SC-004**: Task status update | <500ms in UI | Widget test assertion; frame rate tracking |
| **SC-005**: Timesheet submission | <3 minutes end-to-end | Timed workflow test |
| **SC-010**: Zero timer data loss | 100% preservation across pause/resume/force-close | Integration test + manual force-close test |
| **SC-011**: Responsiveness @ 100 tasks | <2s list render, no lag | Load test with 100 mock tasks |
| **SC-012**: Accessibility compliance | WCAG 2.1 AA | Automated scan + manual screen-reader test |

---

## Known Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|-----------|
| **Timer drift** (device vs. server divergence > 5s) | Medium | Task time data inaccuracy | Implement periodic validation (every 30s); reconciliation algorithm on reconnect |
| **Offline sync failure** (queued actions lost on crash) | Medium | Task/leave/timesheet data loss | Persist sync queue to encrypted local storage; manual retry UI |
| **OAuth token refresh failure** | Low | Session expiration without user action | Implement refresh token rotation; graceful fallback to email/password |
| **Notification delivery failure** (FCM token invalid) | Low | Users miss timely notifications | Re-register token on app launch; fallback to in-app notifications |
| **Cross-platform UI inconsistencies** | Medium | Poor UX on Android or iOS | Implement platform-adaptive widgets; test on real devices in each sprint |
| **Performance regression** (slow task list on 100+ tasks) | Medium | Poor responsiveness | Implement pagination/lazy loading; profile before each sprint review |

---

## Appendices

### A. Glossary

- **Mock API**: In-memory data service simulating backend API for rapid feature development (no backend dependency)
- **Sync Queue**: Local queue of pending API actions (task start, timesheet submit) executed when online
- **Timer Reconciliation**: Process of aligning device-driven timer with server time after offline period
- **Active Task**: Single task currently running timer (one per employee at a time)
- **Private Time**: Temporary pause of active task timer with countdown notification
- **Leave Balance**: Available leave days per type (vacation, casual, sick, parental)

### B. Reference Documents

- Feature Specification: `specs/002-itp-flutter-app/spec.md`
- Constitution: `.specify/memory/constitution.md`
- Mock API Service: `lib/core/network/mock/mock_api_service.dart`
- Research Summary (Phase 0): `specs/002-itp-flutter-app/research.md` (to be generated)

### C. Tech Stack Summary

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **UI Framework** | Flutter 3.19+ | Cross-platform (iOS, Android, Web, Windows, macOS, Linux); Material 3 & HIG support |
| **Language** | Dart 3.11+ | Type-safe, null-safe; excellent Flutter integration |
| **State Management** | Riverpod (recommended) | Reactive, testable, powerful dependency injection; alternatives (Bloc, Provider) TBD in Phase 0 |
| **Routing** | go_router | Modern, nested routing; deep linking support |
| **Persistence** | flutter_secure_storage + Hive/Drift **(TBD) | Secure token storage; optional Hive/Drift for offline persistence |
| **Networking** | http / Dio + MockApiService | Simple API calls; MockApiService for zero-backend development |
| **Notifications** | firebase_messaging | FCM integration for Android/Web/Desktop; platform APIs for iOS/macOS |
| **Local Notifications** | flutter_local_notifications | In-app notification display + platform notification channels |
| **Testing** | test + flutter_test+ integration_test | Unit, widget, and E2E testing in single suite |
| **Code Quality** | flutter_lints + analyzer | Zero-issue target; automated formatting (dart format) |

---

**Plan Status**: ✅ READY FOR PHASE 0 RESEARCH  
**Next Step**: Resolve NEEDS CLARIFICATION items (Section 2); proceed to Phase 0 research tasks and generate `research.md`
