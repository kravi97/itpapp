<!--
  Sync Impact Report
  ==================
  Version change: 1.0.0 → 1.1.0 (MINOR — added Developer and UI/UX sections)
  Modified principles: N/A
  Added sections:
    - Core Principles (BA): 5 principles covering requirements traceability,
      user-story-driven design, acceptance criteria, module boundaries, and
      stakeholder alignment
    - Core Principles (QA): 5 principles covering test-first validation,
      acceptance test coverage, regression safety, cross-platform testing,
      and defect lifecycle management
    - Core Principles (Developer): 5 principles covering module-based
      architecture, state management consistency, security implementation,
      performance standards, and code quality
    - Core Principles (UI/UX): 5 principles covering platform design
      adherence, accessibility compliance, component reusability,
      responsive layout, and user feedback & interaction
    - Technology & Constraints
    - Quality Gates & Workflow
  Removed sections: None
  Templates requiring updates:
    - .specify/templates/plan-template.md: ✅ compatible (Constitution Check
      section already present)
    - .specify/templates/spec-template.md: ✅ compatible (User Scenarios,
      Requirements, and Success Criteria sections align with BA principles)
    - .specify/templates/tasks-template.md: ✅ compatible (user-story-phased
      structure with optional test tasks aligns with QA principles)
  Follow-up TODOs: None
-->

# InTimePro (ITP) Flutter Mobile App Constitution

## Core Principles — Business Analysis (BA)

### I. Requirements Traceability (NON-NEGOTIABLE)

Every feature MUST trace back to a formally identified requirement
from the InTimePro requirement specification (FR-LOGIN-*, FR-HOME-*,
FR-TASK-*, FR-PROJ-*, FR-TIME-*, FR-LEAVE-*, FR-NOT-*, FR-SET-*).

- Each user story, spec entry, and task MUST reference the originating
  requirement ID(s).
- No feature work is permitted without a mapped requirement ID.
- Any gap between the requirement specification and implementation
  MUST be raised as a clarification before coding begins.

### II. User-Story-Driven Design

All functional work MUST be organized as independently testable user
stories, each delivering end-to-end value for the Employee role.

- User stories MUST be prioritized (P1–Pn) and sliced so that each
  story can be developed, tested, and demonstrated independently.
- Stories MUST map to one or more functional modules: Authentication,
  Dashboard, Task Management, Project Management, Timesheet,
  Leave Management, Notifications, or Settings/Profile.
- Cross-module dependencies MUST be explicitly documented in the
  implementation plan.

### III. Acceptance Criteria Completeness

Every user story MUST include measurable acceptance criteria written
in Given/When/Then format before implementation begins.

- Acceptance criteria MUST cover the happy path, at least one error
  path, and any boundary conditions stated in the requirement spec.
- Criteria MUST be technology-agnostic (describe *what*, not *how*).
- Stories without approved acceptance criteria MUST NOT enter
  development.

### IV. Module Boundary Integrity

The eight functional modules defined in the requirement specification
MUST be treated as bounded contexts with clear interfaces.

- Authentication, Dashboard/Home, Task Management, Project
  Management, Timesheet, Leave Management, Notifications, and
  Settings/Profile MUST each have a defined data contract.
- Shared state (e.g., active task shown on Dashboard originates from
  Task Management) MUST be communicated through explicit contracts,
  not ad-hoc coupling.
- New modules MUST NOT be introduced without a constitution amendment.

### V. Stakeholder Alignment

Requirements clarifications and scope changes MUST be documented and
approved before implementation.

- Any ambiguity in the requirement specification (e.g., leave-type
  options, notification delivery channel) MUST be raised as a
  NEEDS CLARIFICATION item in the spec.
- Scope additions beyond the requirement specification MUST follow
  the governance amendment process.
- Feature demos MUST map delivered functionality back to requirement
  IDs for stakeholder sign-off.

## Core Principles — Quality Assurance (QA)

### VI. Test-First Validation

Tests MUST be defined before implementation for every user story.

- Widget tests and unit tests MUST be written (or at minimum
  specified as failing stubs) before the corresponding production
  code.
- The Red → Green → Refactor cycle MUST be followed for all
  business-logic code (models, services, state management).
- Test files MUST mirror the source structure under `test/`.

### VII. Acceptance Test Coverage (NON-NEGOTIABLE)

Every acceptance criterion from the spec MUST have a corresponding
automated test.

- Each FR-* requirement MUST be covered by at least one test that
  validates the stated behavior.
- Integration tests MUST verify cross-module interactions (e.g.,
  starting a task from Dashboard updates Task Management state).
- Test coverage gaps MUST be tracked and resolved before a story is
  marked complete.

### VIII. Regression Safety

No code change may be merged that causes existing tests to fail.

- The full test suite MUST pass before any pull request is approved.
- Flaky tests MUST be quarantined and fixed within the same sprint;
  they MUST NOT be deleted or permanently skipped.
- Breaking changes to module contracts MUST include updated tests
  for all affected consumers.

### IX. Cross-Platform Testing

The application targets multiple platforms (Android, iOS, Web,
Windows, macOS, Linux). Testing MUST account for platform variance.

- Widget and integration tests MUST be executed on at least Android
  and iOS emulators/simulators before release.
- Platform-specific behavior (e.g., notifications, biometrics) MUST
  have dedicated test cases per target platform.
- Web and desktop platforms MUST be smoke-tested for each release
  milestone.

### X. Defect Lifecycle Management

Defects MUST follow a defined lifecycle: Reported → Triaged →
Assigned → Fixed → Verified → Closed.

- Every defect MUST reference the requirement ID and test case that
  exposed it.
- Critical and high-severity defects MUST block the affected story
  from being marked complete.
- Regression defects (previously passing tests now failing) MUST be
  treated as high severity by default.

## Core Principles — Developer

### XI. Module-Based Architecture (NON-NEGOTIABLE)

All source code MUST be organized strictly around the eight
functional modules defined in the requirement specification.

- Each module (Authentication, Dashboard, Task Management, Project
  Management, Timesheet, Leave Management, Notifications,
  Settings/Profile) MUST reside in its own directory under `lib/`
  with a clear internal structure: `models/`, `services/`,
  `screens/`, `widgets/`, and `state/`.
- Cross-module communication MUST occur only through defined service
  interfaces or state management contracts — never through direct
  widget-to-widget coupling.
- Shared utilities (formatters, validators, constants) MUST live in
  a dedicated `lib/core/` or `lib/shared/` directory and MUST NOT
  contain business logic belonging to any single module.
- The eight-module boundary MUST NOT be dissolved or merged without
  a constitution amendment.

### XII. State Management Consistency (NON-NEGOTIABLE)

A single, documented state management solution MUST be used
uniformly across all eight modules.

- The chosen state management approach (e.g., Riverpod, Bloc,
  Provider) MUST be documented in the implementation plan and MUST
  remain consistent across the entire codebase.
- Global application state (authenticated user, active task,
  connection status) MUST be managed at the appropriate scope and
  MUST NOT be stored in local widget state.
- Real-time timer state (FR-016, FR-029) MUST be managed in a
  dedicated state layer that persists across screen navigations.
- State mutations MUST be traceable — no direct state manipulation
  from UI widgets; all mutations go through defined actions or
  notifiers.

### XIII. Security Implementation

All data handling and communication MUST meet the security
requirements specified in FR-001 through FR-013 and the project
constraints.

- All API communication MUST use HTTPS with TLS 1.2+ enforced;
  plain HTTP calls are strictly forbidden (SC-019).
- Sensitive data at rest (credentials, auth tokens, personal data)
  MUST be encrypted using AES-256 via platform-approved secure
  storage (e.g., `flutter_secure_storage`).
- "Remember Me" credential storage (FR-006) MUST use encrypted
  local storage — never plain SharedPreferences or unencrypted files.
- Session tokens MUST be cleared on logout from all pathways
  (FR-115, FR-116); no residual PII MUST remain in plaintext cache.
- OAuth flows for Microsoft (FR-011) and Google (FR-012) MUST use
  PKCE and MUST NOT expose client secrets in the app bundle.
- Input validation MUST be enforced on all user-facing fields before
  any API call is made (e.g., email format, title max-255 chars).

### XIV. Performance Standards

All implemented features MUST satisfy the measurable performance
success criteria defined in the specification.

- Dashboard real-time updates (FR-016, FR-019) MUST reflect within
  1 second of user action (SC-002).
- Task status transitions MUST render in UI within 500 ms (SC-004).
- Calendar timesheet view MUST load and render within 2 seconds
  (SC-013).
- Search and filter operations on tasks and projects MUST return
  results within 1 second (SC-014).
- Timer implementations MUST maintain accuracy with pause/resume
  cycles; zero data loss is required during state transitions
  (SC-011).
- Background timer continuity MUST be handled correctly when the
  app is backgrounded or force-closed, using platform lifecycle
  hooks.
- App MUST remain responsive with up to 100 active tasks per
  employee (SC-012).

### XV. Code Quality & Standards (NON-NEGOTIABLE)

All Dart/Flutter code MUST meet the baseline quality gates before
any pull request is opened.

- `flutter analyze` MUST report zero issues on every commit; no
  lint warnings may be suppressed without written justification in
  code comments.
- `dart format` MUST be applied to all modified files before every
  commit; automated formatting checks MUST be part of CI.
- Public APIs (services, models, state notifiers) MUST have clear,
  concise documentation comments explaining purpose and contract.
- Magic numbers, hard-coded strings (labels, URLs, durations) MUST
  be extracted into named constants or configuration files.
- Dead code (unused imports, unreachable branches, commented-out
  blocks) MUST NOT be committed to the main branch.
- Minimum business-logic test coverage (models, services) MUST be
  maintained at ≥ 80% line coverage (Technology & Constraints).

## Core Principles — UI/UX Design

### XVI. Platform Design Adherence (NON-NEGOTIABLE)

Every screen and component MUST conform to the platform-specific
design system for the target platform.

- Android screens MUST follow Material Design 3 guidelines;
  iOS screens MUST follow Apple's Human Interface Guidelines (HIG).
- Flutter widgets MUST use the appropriate adaptive or
  platform-aware variants where behavioral differences exist
  (e.g., date pickers, alerts, navigation patterns).
- Platform-specific interaction conventions — back gestures on
  Android, swipe-to-dismiss on iOS — MUST be preserved.
- No custom UI pattern that contradicts the target platform's
  conventions may be introduced without explicit stakeholder
  approval.

### XVII. Accessibility Compliance (NON-NEGOTIABLE)

All screens MUST be accessible to users relying on assistive
technologies as required by the project constraints.

- Every interactive element MUST have a meaningful semantic label
  compatible with TalkBack (Android) and VoiceOver (iOS).
- Dynamic text sizing MUST be supported; layouts MUST reflow
  correctly up to 200% system font scale without clipping or
  overflow.
- Color MUST NOT be the sole differentiator for status or state;
  icons or labels MUST accompany color-coded indicators (e.g.,
  green/online, red/overdue) to meet WCAG 2.1 AA contrast
  requirements.
- Touch targets MUST be at least 48 × 48 dp to meet minimum
  accessibility touch-area standards.
- High-contrast mode MUST be tested and functional for all core
  screens before release.

### XVIII. Component Reusability & Design Consistency

UI components MUST be built as reusable widgets aligned with a
single shared design token system.

- Colors, typography, spacing, and border radii MUST be sourced
  from a shared theme file (`lib/core/theme/`) and MUST NOT be
  hard-coded as inline style values in widget trees.
- Status indicators (Pending/orange, Approved/green, Rejected/red
  per FR-076) MUST use a common `StatusBadge` widget — not
  ad-hoc `Container` or `Text` styling duplicated per screen.
- Task priority (Low/Medium/High per FR-024), timer controls
  (start/pause/resume/complete per FR-020), and notification items
  MUST each have a single canonical widget that is reused wherever
  that concept appears.
- New custom widgets MUST NOT be created when an existing widget
  can be parameterized to satisfy the requirement.

### XIX. Responsive & Adaptive Layout

All screens MUST render correctly across the full range of device
sizes, orientations, and platforms targeted by the specification.

- Layouts MUST be tested on small phones (≥ 360 dp width), large
  phones, and tablets without requiring horizontal scrolling on
  content intended for vertical flow.
- Calendar views (FR-050–FR-058), task lists (FR-027–FR-036), and
  project cards (FR-038–FR-049) MUST use flexible/expanded layout
  constructs — hard-coded pixel widths are forbidden.
- Portrait and landscape orientations MUST both be functional for
  all core screens; critical information MUST NOT be hidden in
  landscape mode.
- Web and desktop builds MUST be smoke-tested at each release
  milestone to catch layout regressions on wider viewports.

### XX. User Feedback & Interaction Standards

Every user action that triggers an async operation or state change
MUST provide immediate, clear feedback.

- Loading indicators MUST be displayed during all authentication
  (FR-005), data-fetch, and submission operations; the UI MUST NOT
  appear frozen.
- Success messages MUST confirm completed operations (FR-026,
  FR-106) within 500 ms of server acknowledgement.
- Error messages MUST be human-readable, actionable, and specific
  (FR-004); generic "Something went wrong" messages are forbidden
  for anticipated failure modes.
- Confirmation dialogs MUST be used before all destructive or
  irreversible actions: task completion (FR-036), timesheet
  submission (FR-060), and logout (FR-113).
- Form validation feedback MUST appear inline adjacent to the
  offending field — not only as a top-level banner — so users can
  identify and fix errors in one step (FR-105).

## Technology & Constraints

- **Framework**: Flutter (Dart 3.11+), cross-platform targeting
  Android, iOS, Web, Windows, macOS, Linux.
- **Architecture**: Module-based structure aligned with the eight
  functional modules in the requirement specification.
- **State Management**: MUST use a single, documented state
  management approach across all modules.
- **Authentication**: MUST support email/password, Microsoft account,
  and Google account login (FR-LOGIN-1 through FR-LOGIN-5).
- **Code Quality**: `flutter analyze` MUST report zero issues;
  `dart format` MUST be applied before every commit.
- **Minimum Test Coverage**: Business-logic layers (models, services)
  MUST maintain ≥80% line coverage.

## Quality Gates & Workflow

- **Gate 1 — Spec Review**: Spec MUST include all mapped requirement
  IDs, prioritized user stories, and complete acceptance criteria.
  BA Principles I–V MUST be satisfied.
- **Gate 2 — Plan Review**: Implementation plan MUST pass the
  Constitution Check (plan-template § Constitution Check) against
  all twenty principles before Phase 0 research begins.
- **Gate 3 — Design Review**: UI/UX wireframes or screen designs
  MUST be reviewed against Principles XVI–XX (platform adherence,
  accessibility, component reuse, responsive layout, user feedback)
  before any screen implementation begins.
- **Gate 4 — Test Readiness**: Failing test stubs for the current
  story MUST exist before implementation starts (QA Principle VI).
  Developer architectural decisions MUST be documented in the plan
  (Developer Principles XI–XII).
- **Gate 5 — PR Approval**: Full test suite MUST pass; `flutter
  analyze` clean with zero issues (Developer Principle XV);
  acceptance tests for the story's FR-* requirements MUST be green.
  UI changes MUST be verified on at least one Android and one iOS
  device or emulator (UI/UX Principle XIX). At least one reviewer
  MUST verify compliance with this constitution.
- **Gate 6 — Story Completion**: Acceptance criteria verified, no
  open critical/high defects, cross-platform smoke tests passed,
  accessibility spot-check completed (UI/UX Principle XVII).

## Governance

This constitution is the authoritative set of rules for the InTimePro
Flutter Mobile App project. It supersedes all other ad-hoc practices.

- **Amendments**: Any change to this constitution MUST be documented
  with a version bump, rationale, and migration plan for affected
  artifacts.
- **Versioning**: Follows semantic versioning — MAJOR for principle
  removals/redefinitions, MINOR for additions/expansions, PATCH for
  clarifications and typo fixes.
- **Compliance Review**: Every PR review MUST include a check against
  the applicable BA, QA, Developer, and UI/UX principles.
  Non-compliance MUST be resolved before merge.
- **Complexity Justification**: Any deviation from simplicity (extra
  abstractions, additional modules beyond the eight defined, new
  custom widgets when reusable ones exist) MUST be justified in
  writing and approved via the amendment process.
- **Role Responsibility**: BA owns Principles I–V; QA owns
  Principles VI–X; Developers own Principles XI–XV; UI/UX Designers
  own Principles XVI–XX. Cross-role reviews are encouraged for
  principles that span boundaries (e.g., Principle XIII affects
  both Developer and BA).

**Version**: 1.0.0 | **Ratified**: 2026-03-12 | **Last Amended**: 2026-03-12