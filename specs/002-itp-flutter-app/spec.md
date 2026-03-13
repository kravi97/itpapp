# Feature Specification: InTimePro (ITP) Flutter Mobile Application

**Feature Branch**: `002-itp-flutter-app`
**Created**: March 13, 2026
**Status**: Draft
**Input**: User description: "Build InTimePro Flutter mobile app for employee time tracking, task management, timesheet submission, leave management, notifications, and profile settings"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Employee Login & Authentication (Priority: P1)

An employee opens the InTimePro mobile app and logs in using their email and password, Microsoft account, or Google account. The system authenticates the user, loads their profile, and navigates to the dashboard. The employee can opt to stay logged in via "Remember Me" and recover forgotten passwords through email-based reset.

**Requirement IDs**: FR-LOGIN-1, FR-LOGIN-2, FR-LOGIN-3, FR-LOGIN-4, FR-LOGIN-5

**Why this priority**: Authentication is the entry point for all app functionality. Without secure login, no other module is accessible.

**Independent Test**: Can be fully tested by launching the app, entering credentials (valid and invalid), using social login buttons, toggling Remember Me, and completing the forgot-password flow. Delivers immediate value by securing access to the system.

**Acceptance Scenarios**:

1. **Given** an employee has valid email/password credentials, **When** they enter credentials and tap Login, **Then** a loading indicator appears, authentication succeeds, and the dashboard screen loads
2. **Given** an employee enters an invalid email or wrong password, **When** they tap Login, **Then** a clear error message displays explaining the issue and the login button re-enables
3. **Given** an employee checks "Remember Me" before logging in, **When** they close and reopen the app, **Then** their email is auto-filled and the session persists without re-entering credentials
4. **Given** an employee has forgotten their password, **When** they tap "Forgot Password" and enter their email, **Then** a password reset link is sent to their email, valid for 24 hours
5. **Given** an employee taps "Sign in with Microsoft" or "Sign in with Google", **When** they complete OAuth authentication with their provider, **Then** the app creates or links their account and syncs profile data from the provider
6. **Given** the Login button exists, **When** email or password fields are empty, **Then** the Login button is disabled and cannot be tapped

---

### User Story 2 - Real-Time Dashboard & Work Status (Priority: P1)

After login, the employee sees a dashboard showing their current clock-in time, active working hours (updating in real time), total time at work, and currently active task. The employee can start, pause, resume, or complete tasks directly from the dashboard using quick-action buttons.

**Requirement IDs**: FR-HOME-1, FR-HOME-2, FR-HOME-3, FR-HOME-4, FR-HOME-5, FR-HOME-6, FR-HOME-7, FR-HOME-8

**Why this priority**: The dashboard is the primary screen employees interact with throughout the workday. It provides at-a-glance status and direct task control, making it essential for core usability.

**Independent Test**: Can be tested by clocking in, starting a task, observing real-time timer updates, pausing/resuming tasks, and completing a task from the dashboard. Delivers value by giving employees immediate visibility into their work status.

**Acceptance Scenarios**:

1. **Given** an employee has clocked in, **When** they view the dashboard, **Then** clock-in time displays in HH:MM format with a green "online" status indicator
2. **Given** an employee is working, **When** they view "Active Hours", **Then** the display shows time in HH:MM format and updates every second in real time, excluding paused periods
3. **Given** an employee has a running task, **When** they view the dashboard, **Then** the active task card shows task name, task ID, elapsed time, billable status, and category with pause and complete buttons
4. **Given** an employee taps "Start" on a new task, **When** another task is already active, **Then** the previous task auto-pauses, a confirmation notification appears, and the new task timer begins
5. **Given** an employee taps "Complete" on the active task, **When** a confirmation dialog appears and the employee confirms, **Then** the task is marked complete, the timer stops, and the completion timestamp is recorded

---

### User Story 3 - Task Creation & Lifecycle Management (Priority: P1)

An employee creates new tasks by providing a title, selecting a project, setting estimated hours, choosing a priority, and optionally adding a description. Tasks progress through a lifecycle: New → In Progress → Overdue → Completed. The employee manages tasks via tabbed views showing counts for each status. Time tracking runs automatically when a task is started.

**Requirement IDs**: FR-TASK-1, FR-TASK-2, FR-TASK-3, FR-TASK-4, FR-TASK-5, FR-TASK-6, FR-TASK-7, FR-TASK-8, FR-TASK-9, FR-TASK-10

**Why this priority**: Task management is the core engine of the time tracking system. Employees must create and track tasks to generate accurate timesheets and measure productivity.

**Independent Test**: Can be tested by creating a task with all fields, starting the timer, observing status transitions, pausing/resuming, letting time exceed the estimate to trigger "Overdue", and completing the task. Delivers value by enabling structured work tracking.

**Acceptance Scenarios**:

1. **Given** an employee taps "Create Task", **When** they fill in title (max 255 chars), select a project, set estimated hours, choose priority (Low/Medium/High), and submit, **Then** the task is created with "New" status and a success message is shown
2. **Given** tasks exist across statuses, **When** the employee views the task list, **Then** tabs display New, In Progress, Overdue, and Completed with badge counts, and each tab shows the relevant tasks
3. **Given** an employee starts a task, **When** the timer begins, **Then** the status changes to "In Progress" and only this single task can be active at a time
4. **Given** a task's elapsed time exceeds its estimated hours, **When** the task is still in progress, **Then** the status automatically changes to "Overdue" with a red visual warning showing the overtime amount
5. **Given** an employee taps "Complete" on a task, **When** they confirm in the dialog, **Then** the task moves to the Completed tab with the completion timestamp recorded and the timer stops

---

### User Story 4 - Timesheet Logging & Submission (Priority: P1)

An employee logs hours against tasks using a monthly calendar interface. They can manually enter time for specific dates, link hours to projects, and add notes. Once daily work is complete, the employee submits their timesheet, which locks it as read-only. They can view submission history, approval status, and totals for logged versus submitted hours.

**Requirement IDs**: FR-TIME-1, FR-TIME-2, FR-TIME-3, FR-TIME-4, FR-TIME-5, FR-TIME-6, FR-TIME-7, FR-TIME-8

**Why this priority**: Timesheet submission is critical for payroll processing, client billing, and regulatory compliance. This is a primary business requirement alongside task management.

**Independent Test**: Can be tested by navigating the calendar, logging hours for a date, linking to a project, submitting the timesheet, and verifying it locks. Delivers value by recording billable hours and enabling payroll.

**Acceptance Scenarios**:

1. **Given** an employee opens the Timesheet screen, **When** the calendar loads, **Then** a monthly view displays with hours logged per date, the current day highlighted, and month navigation arrows
2. **Given** an employee selects a date, **When** they log hours with time range, project, and notes, **Then** the hours appear on the calendar for that date
3. **Given** an employee has finished daily work, **When** they tap "Submit Timesheet" and confirm, **Then** the timesheet locks as read-only with a submission timestamp recorded
4. **Given** submitted timesheets exist, **When** the employee views history, **Then** a list shows submitted dates, hours, and approval status, with no edit option
5. **Given** an employee views totals, **When** the summary loads, **Then** logged hours (e.g., "40:35 hrs"), submitted hours (e.g., "20:50 hrs"), the difference, and weekly/monthly totals are displayed

---

### User Story 5 - Project Visibility & Progress Tracking (Priority: P2)

An employee views all projects assigned to them, including project name, progress percentage, start/end dates, team members, and task breakdown. They can track deadlines, see days remaining, and view team composition through avatar displays.

**Requirement IDs**: FR-PROJ-1, FR-PROJ-2, FR-PROJ-3, FR-PROJ-4, FR-PROJ-5, FR-PROJ-6

**Why this priority**: Project visibility provides context for task work and helps employees understand deadlines and team collaboration. Important but not required for basic time tracking operations.

**Independent Test**: Can be tested by viewing the project list, checking progress bars, reviewing team avatars, and verifying date calculations. Delivers value by providing employees with work context and deadline awareness.

**Acceptance Scenarios**:

1. **Given** an employee has assigned projects, **When** they view the project list, **Then** each project shows name, progress percentage (0-100%), date range in "MMM DD, YYYY" format, and team member count
2. **Given** tasks within a project are completed, **When** progress is recalculated, **Then** the progress bar updates with color-coded percentage (green for on-track progress)
3. **Given** a project has an end date, **When** the employee views it, **Then** days remaining are displayed, with a visual warning if the project is overdue
4. **Given** a project has team members, **When** the employee views the project, **Then** up to 4 member avatars display with a "+X" indicator for additional members, and tapping opens the full team list
5. **Given** a project has tasks, **When** the employee views the project detail, **Then** total task count and breakdown by status (New/In Progress/Overdue/Completed) are shown

---

### User Story 6 - Leave Application & Balance Management (Priority: P2)

An employee applies for leave by selecting a date range, choosing a leave type (Vacation, Casual, Sick, Parental), and optionally adding notes. They can track application status (Pending/Approved/Rejected), view leave balances, see annual entitlements, and manage existing approved leave.

**Requirement IDs**: FR-LEAVE-1, FR-LEAVE-2, FR-LEAVE-3, FR-LEAVE-4, FR-LEAVE-5, FR-LEAVE-6, FR-LEAVE-7

**Why this priority**: Leave management is important for workforce planning and employee self-service, but not critical for daily time tracking. Can be implemented after core P1 features.

**Independent Test**: Can be tested by applying for leave, checking status badges, verifying balance calculations, and attempting to cancel approved leave. Delivers value by automating leave requests and providing balance visibility.

**Acceptance Scenarios**:

1. **Given** an employee needs time off, **When** they open the leave form, **Then** they can select a date range (past dates blocked, already-booked dates blocked), choose a leave type from a dropdown showing balances, add optional notes, and submit
2. **Given** a leave type is selected, **When** the dropdown displays, **Then** each type shows its name, description, and remaining balance
3. **Given** a leave application is submitted, **When** the status is determined, **Then** it displays as Pending (orange badge), Approved (green badge), or Rejected (red badge with reason)
4. **Given** the employee views balances, **When** the leave screen loads, **Then** it shows available days, currently booked days, and annual balance with detailed breakdown by type including allocation and expiry dates
5. **Given** approved leave exists, **When** the employee views booked leave, **Then** a list shows approved periods with dates, number of days, leave type, and a cancellation option where policy allows

---

### User Story 7 - Activity Notifications & Reminders (Priority: P3)

An employee receives push and in-app notifications for task actions (start, pause, complete), timesheet submission reminders at end of day, and leave status updates. Notifications are tappable and navigate to the relevant screen.

**Requirement IDs**: FR-NOT-1, FR-NOT-2, FR-NOT-3, FR-NOT-4, FR-NOT-5

**Why this priority**: Notifications enhance engagement and remind employees of pending actions, but the application is fully functional without them.

**Independent Test**: Can be tested by triggering task start/stop actions, waiting for end-of-day reminders, submitting leave, and observing notification delivery and content. Delivers value by keeping employees informed without needing to check the app.

**Acceptance Scenarios**:

1. **Given** an employee starts or stops a task, **When** the action occurs, **Then** push and in-app notifications are sent showing task name, timestamp, and elapsed time (for stop)
2. **Given** it is end of workday (e.g., 5:30 PM), **When** the timesheet has not been submitted, **Then** a reminder notification is sent showing pending hours with tap-to-open functionality to the timesheet screen
3. **Given** an employee submits a leave application, **When** submission succeeds, **Then** a confirmation notification is sent showing applied dates and leave type
4. **Given** a leave status changes, **When** it is approved or rejected, **Then** a push notification is sent with approval confirmation or rejection reason
5. **Given** a task is completed, **When** completion is confirmed, **Then** a notification is sent showing total time spent and completion timestamp

---

### User Story 8 - Profile & Settings Management (Priority: P3)

An employee views and updates their profile (name, phone, password, picture), configures notification preferences, enables private time timers that pause task tracking, and securely logs out from the application with session cleanup.

**Requirement IDs**: FR-SET-1, FR-SET-2, FR-SET-3, FR-SET-4, FR-SET-5

**Why this priority**: Profile management supports personalization and security but is not core to time tracking. Can be implemented after all other features.

**Independent Test**: Can be tested by editing profile fields, toggling notification settings, enabling private time with duration, and verifying logout clears session and cache. Delivers value through personalization and account security.

**Acceptance Scenarios**:

1. **Given** an employee opens their profile, **When** the account section loads, **Then** it displays name, email, employee ID, department, designation, and profile picture
2. **Given** an employee edits their name, phone, or password, **When** they save changes, **Then** validation runs, changes persist, and a success message displays
3. **Given** an employee enables private time, **When** the toggle is activated, **Then** duration options (15 min / 30 min / custom) appear, the countdown starts, the active task timer pauses, and a notification fires when private time ends
4. **Given** an employee taps "Logout", **When** the confirmation dialog appears with options for current device or all devices, **Then** session data and cache are cleared, and the app redirects to the login screen
5. **Given** an employee opens notification settings, **When** toggles are displayed, **Then** they can enable/disable app notifications, push notifications, sounds, and configure quiet hours

---

### Edge Cases

- What happens when an employee starts a task while offline and connectivity is restored?
- How does the system handle a running task timer when the app is force-closed or the device restarts?
- What happens when leave application dates overlap with existing approved leave?
- How does the system behave when the timesheet submission deadline is missed?
- What happens when the employee's annual leave balance is insufficient for the requested days?
- How does the system handle task completion when elapsed time significantly exceeds the estimate?
- What happens when an employee tries to edit a submitted and approved timesheet?
- How does the system handle multiple rapid start/stop actions on task timers?
- What happens when a project end date passes but tasks remain incomplete?
- How does the system reconcile time tracking when the device time zone changes mid-day?
- What happens when "Remember Me" credentials become invalid (e.g., password changed on another device)?
- How does the system behave when push notification permissions are denied by the OS?

## Requirements *(mandatory)*

### Functional Requirements

#### Authentication Module (FR-LOGIN-*)

- **FR-LOGIN-1**: System MUST authenticate users via email/password with valid email format validation, password visibility toggle, and Login button disabled when either field is empty
- **FR-LOGIN-2**: System MUST display clear error messages for invalid credentials and show a loading indicator during the authentication process
- **FR-LOGIN-3**: System MUST support "Remember Me" with encrypted local credential storage, auto-fill email on app relaunch, and clear saved credentials on explicit logout
- **FR-LOGIN-4**: System MUST provide forgot-password functionality with an email-based reset link that expires after 24 hours
- **FR-LOGIN-5**: System MUST support Microsoft OAuth and Google OAuth authentication, creating a new account on first social login and syncing profile data from the provider

#### Dashboard Module (FR-HOME-*)

- **FR-HOME-1**: System MUST display the employee's clock-in time in HH:MM format
- **FR-HOME-2**: System MUST show real-time online/offline status with a visual indicator (green = online, red = offline)
- **FR-HOME-3**: System MUST display active working hours in HH:MM format with real-time second-by-second updates, excluding paused periods
- **FR-HOME-4**: System MUST display total time at work in HH:MM:SS format, inclusive of breaks
- **FR-HOME-5**: System MUST show the currently active task with name, ID, elapsed time, billable status, and category
- **FR-HOME-6**: System MUST provide quick-action buttons (start/pause/resume/complete) for task control directly from the dashboard
- **FR-HOME-7**: System MUST display a confirmation dialog before completing a task from the dashboard
- **FR-HOME-8**: System MUST auto-pause the previous active task when a new task is started, with a confirmation notification

#### Task Management Module (FR-TASK-*)

- **FR-TASK-1**: System MUST allow task creation with required fields: title (max 255 characters), project selection, and estimated hours; and optional fields: description and priority (Low/Medium/High)
- **FR-TASK-2**: System MUST initialize new tasks with "New" status and display a success message after creation
- **FR-TASK-3**: System MUST organize tasks into tabs: New, In Progress, Overdue, Completed, each showing a badge with the task count
- **FR-TASK-4**: System MUST allow starting a task timer which changes the task status to "In Progress"
- **FR-TASK-5**: System MUST enforce a single active task constraint by auto-pausing any previously active task
- **FR-TASK-6**: System MUST automatically change task status to "Overdue" when elapsed time exceeds estimated time, with a red visual warning showing the overtime amount
- **FR-TASK-7**: System MUST provide pause and resume buttons to stop/continue the timer without completing the task
- **FR-TASK-8**: System MUST provide a complete button with confirmation dialog that records the completion timestamp
- **FR-TASK-9**: System MUST support task sorting or filtering within each tab
- **FR-TASK-10**: System MUST display task details including elapsed time, estimated time, project association, and priority

#### Project Management Module (FR-PROJ-*)

- **FR-PROJ-1**: System MUST display a list of all projects assigned to the logged-in employee with name, progress percentage (0-100%), start date, end date, and team member count
- **FR-PROJ-2**: System MUST calculate project progress as the ratio of completed tasks to total tasks with a color-coded progress bar
- **FR-PROJ-3**: System MUST format project dates as "MMM DD, YYYY" and calculate/display days remaining until the end date, with visual warning for overdue projects
- **FR-PROJ-4**: System MUST show team member avatars with "+X" indicator when there are more than 4 members, with tap-to-expand for the full team list
- **FR-PROJ-5**: System MUST display total task count per project with breakdown by status (New/In Progress/Overdue/Completed)
- **FR-PROJ-6**: System MUST support sorting projects by progress or dates

#### Timesheet Management Module (FR-TIME-*)

- **FR-TIME-1**: System MUST provide a monthly calendar view with hours logged on each date, current day highlighted, and month-to-month navigation
- **FR-TIME-2**: System MUST allow manual hour entry for specific dates with time range selection, project linkage, and optional notes
- **FR-TIME-3**: System MUST update the calendar display when hours are logged
- **FR-TIME-4**: System MUST provide a submit button with confirmation dialog that locks the daily timesheet as read-only and records the submission timestamp
- **FR-TIME-5**: System MUST prevent editing of submitted timesheets
- **FR-TIME-6**: System MUST display submission history showing dates, hours, and approval status
- **FR-TIME-7**: System MUST display total logged hours, total submitted hours, and the difference between them in HH:MM format
- **FR-TIME-8**: System MUST provide weekly and monthly hour totals

#### Leave Management Module (FR-LEAVE-*)

- **FR-LEAVE-1**: System MUST provide a leave application form with date range picker (past dates disabled, already-booked dates blocked), leave type selector (Vacation, Casual, Sick, Parental), and optional notes field
- **FR-LEAVE-2**: System MUST display leave balance for each leave type in the dropdown, with type descriptions
- **FR-LEAVE-3**: System MUST calculate the number of leave days from the selected date range
- **FR-LEAVE-4**: System MUST display leave status as Pending (orange), Approved (green), or Rejected (red with reason)
- **FR-LEAVE-5**: System MUST display available leave days, currently booked days, and annual leave balance with detailed breakdown by type
- **FR-LEAVE-6**: System MUST display annual leave entitlement with allocation date, expiry date, and carry-over balance if applicable
- **FR-LEAVE-7**: System MUST display approved leave periods with dates, days, leave type, and provide cancellation option where allowed by policy

#### Notifications Module (FR-NOT-*)

- **FR-NOT-1**: System MUST send push and in-app notifications when a task is started (showing task name and start time), paused (showing elapsed time), or completed (showing total time spent and timestamp)
- **FR-NOT-2**: System MUST send a timesheet submission reminder at configured end-of-day time (e.g., 5:30 PM) showing pending hours, with tap-to-open functionality to the timesheet screen
- **FR-NOT-3**: System MUST send confirmation notification when leave is submitted and status-change notification when leave is approved or rejected (including rejection reason)
- **FR-NOT-4**: System MUST support notification dismissal and maintain in-app notification history
- **FR-NOT-5**: System MUST support customizable notification preferences (app/push toggle, sound settings, quiet hours)

#### Settings/Profile Module (FR-SET-*)

- **FR-SET-1**: System MUST display employee account information: name, email, employee ID, department, designation, and profile picture
- **FR-SET-2**: System MUST allow updating name (if policy permits), phone number, password (with validation), and profile picture, with success message on save
- **FR-SET-3**: System MUST provide a private time toggle with duration options (15 min / 30 min / custom) that pauses the active task timer, runs a countdown, and sends notification when time ends
- **FR-SET-4**: System MUST provide logout with confirmation dialog offering "current device" or "all devices" options, clearing session data, cached data, and redirecting to the login screen
- **FR-SET-5**: System MUST provide notification preference toggles for app notifications, push notifications, notification sounds, and optional quiet hours configuration

### Key Entities

- **User**: Employee account with authentication credentials (email, password, social auth tokens), profile information (name, employee ID, department, designation, profile picture), preferences (remember me, notification settings, private time), and session tracking

- **Task**: Work activity with identifying information (title, description, category), project association, time tracking data (estimated hours, elapsed hours, start/stop timestamps), status lifecycle (New → In Progress → Overdue → Completed), priority level (Low/Medium/High), and billing attributes

- **Project**: Work initiative with name, description, timeline (start/end dates), progress metrics (completion percentage based on task ratio), team composition (members with avatars), and task breakdown by status

- **Timesheet**: Logged work hours per date with employee association, task linkage, hour amount, notes, submission state (draft/submitted/approved/rejected), submission timestamp, and approval tracking

- **Leave**: Time-off request with employee association, leave type (Vacation/Casual/Sick/Parental), date range (start/end/days), status workflow (Pending/Approved/Rejected), and rejection reason if applicable

- **LeaveBalance**: Time-off entitlement per type with available units, booked units, annual allocation, carry-over amounts, allocation date, and expiry date

- **Notification**: System alert with user target, type classification (task event, timesheet reminder, leave status), content (title, message), related entity reference, read status, and timestamp

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Employees can complete the login process in under 15 seconds using any authentication method (email/password, Microsoft, Google)
- **SC-002**: Dashboard displays current work status with real-time timer updates within 1 second of user action
- **SC-003**: 95% of employees successfully create and start their first task within 2 minutes of accessing the dashboard
- **SC-004**: Task status transitions (start, pause, complete) reflect in the UI within 500 milliseconds
- **SC-005**: Employees can log hours and submit a daily timesheet in under 3 minutes
- **SC-006**: Timesheet submission succeeds on first attempt for 98% of submissions
- **SC-007**: Leave applications are submitted successfully within 2 minutes of opening the leave form
- **SC-008**: 90% of users receive and acknowledge notifications within 10 seconds of the triggering event
- **SC-009**: Profile updates save successfully within 3 seconds with immediate validation feedback
- **SC-010**: Zero data loss occurs during timer transitions (start, pause, stop, complete)
- **SC-011**: Application remains responsive with up to 100 active tasks per employee
- **SC-012**: Calendar-based timesheet view loads and renders within 2 seconds
- **SC-013**: Average time to find and start a task is under 30 seconds
- **SC-014**: Employee satisfaction score for time tracking ease-of-use exceeds 4 out of 5
- **SC-015**: System maintains 99.5% uptime during business hours

## Assumptions

- **User Base & Scale**: System targets medium-scale deployment (100-1,000 employees) with 20-50 concurrent users during peak hours and 5-20 tasks per employee per day
- Employees have access to iOS or Android mobile devices with internet connectivity
- Company provides backend API infrastructure for authentication, data storage, and synchronization
- Leave policies support the standard types (Vacation, Casual, Sick, Parental) with configurable balances
- Projects are pre-created and assigned to employees by administrators or project managers
- Time tracking follows an elapsed-time model (timer-based) with manual entry as a supplement
- Single active task constraint aligns with company policy for accurate time allocation
- Timesheet submission occurs daily with approval workflow handled outside the mobile app
- Notifications use standard push services (APNs for iOS, FCM for Android)
- Profile data such as employee ID, department, and designation is managed centrally and synced
- Social authentication (Microsoft, Google) requires corporate OAuth apps configured in the backend
- Task overdue detection is automatic (elapsed time > estimated time) without manual intervention
- Password reset links are delivered via company email infrastructure
- Leave balance calculations include annual allocation, carry-over, and booked amounts

## Dependencies

- Backend REST API services for authentication, task management, project data, timesheet submission, and leave management
- OAuth provider integrations (Microsoft Azure AD, Google Identity Platform) for social login
- Push notification infrastructure (Apple Push Notification Service, Firebase Cloud Messaging)
- Secure local storage for credentials and offline data caching
- Email service for password reset delivery
- HR system integration for employee profile data synchronization
- Project management system integration for project and task assignment data

## Constraints

- Must target iOS 13+ and Android 8.0+ as minimum platform versions
- Must use secure communication (HTTPS, TLS 1.2+) for all API calls
- Must encrypt sensitive data at rest (AES-256 for credentials, personal information)
- Must respect platform-specific UI guidelines (Material Design for Android, Human Interface Guidelines for iOS)
- Must support accessibility features (screen readers, dynamic text sizing, high contrast)
- Must operate within mobile device battery constraints for background timers and sync frequency
- Fail-fast strategy for API failures: show error immediately, require manual retry, no offline fallback
- Completed timesheets retained indefinitely for audit/payroll; task/project data retained 12 months post-completion; personal data deleted within 30 days of offboarding
- ERROR-level application logging only; no real-time metrics or distributed tracing

## Out of Scope

- Administrative features (HR admin, project manager, system administrator roles)
- Timesheet and leave approval workflows (handled outside mobile app)
- Project creation, modification, and assignment functionality
- Reporting, analytics dashboards, and productivity metrics
- Payroll integration and invoice generation
- Multi-language support and internationalization
- Biometric authentication (fingerprint, face recognition)
- Geolocation-based clock-in/clock-out
- File attachments or document uploads
- Task dependencies and Gantt charts
- External calendar integration (Google Calendar, Outlook)
- Chat or video calling features
- Expense tracking and reimbursement
- White-labeling and multi-tenant support
- Third-party project management tool integration (Jira, Asana, Trello)
- Bulk operations (bulk task creation, bulk leave application)
- Export functionality for timesheets and reports
