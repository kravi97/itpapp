<!--
  Sync Impact Report
  ==================
  Version change: 1.0.0 → 1.1.0 (MINOR — added Developer and UI/UX principle sections)
  Modified principles: N/A
  Added sections:
    - Core Principles (BA): 5 principles covering requirements traceability,
      user-story-driven design, acceptance criteria, module boundaries, and
      stakeholder alignment
    - Core Principles (QA): 5 principles covering test-first validation,
      acceptance test coverage, regression safety, cross-platform testing,
      and defect lifecycle management
    - Core Principles (Developer): 5 principles covering module-based
      architecture, single state management pattern, security-first
      implementation, fail-fast API strategy, and code quality standards
    - Core Principles (UI/UX): 5 principles covering platform design
      guideline adherence, accessibility compliance, consistent visual
      design system, real-time feedback & responsiveness, and navigation
      & information architecture
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

Code MUST be organised around the eight functional modules defined in
the requirement specification, with no cross-module coupling beyond
explicitly defined contracts.

- Each module (Authentication, Dashboard, Task Management, Project
  Management, Timesheet, Leave Management, Notifications,
  Settings/Profile) MUST have its own folder containing clearly
  separated layers: models, repositories, services, state, and UI.
- Cross-module communication MUST use defined data contracts or
  interfaces; direct imports between module internals are forbidden.
- Shared utilities (constants, extensions, theme, networking,
  secure storage) MUST live in a single `core/` or `shared/` layer
  and MUST NOT contain business logic specific to any one module.
- Introducing a layer or sub-module not present in this layout MUST
  follow the constitution amendment process.

### XII. Single State Management Pattern (NON-NEGOTIABLE)

A single, documented state management solution MUST be adopted and
applied uniformly across all eight modules before Phase 1 begins.

- The chosen approach MUST be recorded in the implementation plan
  and approved before any feature development starts.
- Mixing multiple state management patterns (e.g., BLoC alongside
  Provider or Riverpod) is strictly prohibited.
- Global state (authenticated user session, active task) MUST be
  managed at the application level with explicit, typed subscriptions.
- State classes MUST be immutable; mutations MUST go through the
  documented state-management update mechanism only.

### XIII. Security-First Implementation (NON-NEGOTIABLE)

All implementation MUST satisfy the security constraints declared in
the requirement specification and Technology & Constraints section.

- Credentials and all sensitive data MUST be encrypted with AES-256
  at rest using `flutter_secure_storage` or an equivalent vetted
  library; plain `SharedPreferences` MUST NOT store sensitive data.
- Every API call MUST use TLS 1.2+ (HTTPS); plaintext HTTP
  connections MUST be rejected at the network layer.
- OAuth tokens (Microsoft, Google) MUST be stored in secure storage
  and fully revoked and deleted on logout (FR-008, FR-115, FR-116).
- Audit log entries MUST be generated for: authentication events,
  password changes, timesheet submissions, and leave approvals.
- No credentials, secrets, API keys, or environment-specific URLs
  MUST appear in source code; use environment variables or
  platform-level secret stores.

### XIV. Fail-Fast API & Error Handling

All external API failures MUST be surfaced immediately with clear,
user-readable messages; silent failures and hidden retry loops are
prohibited.

- Every network call MUST display a loading indicator during
  execution (FR-005) and show a specific error message on failure
  (FR-004, FR-026, FR-106).
- No automatic background retry or silent fallback to stale data is
  permitted, except for the offline task-timer sync defined in SC-009.
- Each API call MUST define and enforce a maximum timeout; indefinite
  pending states are forbidden.
- Error messages MUST be meaningful to the employee (not raw HTTP
  status codes or stack traces) and guide the user to retry or take
  corrective action.

### XV. Code Quality Standards (NON-NEGOTIABLE)

All production code MUST clear the automated quality bar on every
commit without exception.

- `flutter analyze` MUST report zero issues; analyzer warnings are
  treated as errors and MUST be resolved before merging.
- `dart format` MUST be applied to every Dart file before each commit;
  formatting diffs MUST NOT appear in pull requests.
- Business-logic layers (models, services, state management) MUST
  maintain ≥ 80 % line coverage as measured by `flutter test --coverage`.
- TODO / FIXME comments in production code MUST reference a linked
  issue; untracked TODOs MUST NOT be merged.
- Public module APIs and service interfaces MUST be documented with
  DartDoc comments explaining purpose, parameters, and return values.

## Core Principles — UI/UX

### XVI. Platform Design Guideline Adherence

The application MUST respect both Material Design 3 (Android) and
Apple Human Interface Guidelines (iOS) for all UI components and
interaction patterns.

- Platform-adaptive widgets MUST be used: bottom navigation bar on
  Android; tab bar or equivalent iOS navigation on iOS where the
  platform standard differs.
- Touch targets MUST meet platform minimums: 48 × 48 dp (Material 3)
  and 44 × 44 pt (HIG); nothing tappable may fall below these sizes.
- Platform-appropriate press feedback MUST be applied: ink ripple on
  Android, opacity or fill animation on iOS.
- System date pickers, time pickers, and alert dialogs MUST use
  platform-appropriate variants unless a shared custom component
  is necessary and approved.

### XVII. Accessibility Compliance (NON-NEGOTIABLE)

All UI components MUST support the accessibility features required
by the specification constraints without exception.

- Every interactive element MUST carry a meaningful semantic label
  consumable by TalkBack (Android) and VoiceOver (iOS).
- The app MUST respect the system font-scale setting at all sizes;
  no layout may break or clip text when font scale is increased.
- Color MUST NOT be the sole indicator of state — every color-coded
  status (green/orange/red for task and leave states per FR-015,
  FR-032, FR-076) MUST be supplemented by an icon, badge text, or
  pattern.
- High-contrast display modes MUST be supported without information
  loss or invisible UI elements.
- Text contrast MUST meet WCAG AA minimums: 4.5 : 1 for normal text,
  3 : 1 for large text (18 sp+ regular or 14 sp+ bold).

### XVIII. Consistent Visual Design System

A single, documented design system MUST be established and applied
uniformly across all eight modules before screen implementation begins.

- A defined color palette, typography scale, spacing grid (8 dp base
  unit), elevation levels, and shared widget library MUST be created
  and reviewed before any module UI is built.
- Module screens MUST compose from shared components; duplicating
  UI code across modules is prohibited — extract to the shared
  component library instead.
- Status color conventions MUST be globally consistent:
  green = active / on-track, orange / amber = pending / warning,
  red = overdue / error, as defined across FR-015, FR-032, and
  FR-076.
- A single icon family and style MUST be chosen; mixing multiple
  icon sets within the same screen is forbidden.

### XIX. Real-Time Feedback & Responsiveness

All user interactions MUST deliver immediate visual feedback and the
UI MUST remain responsive during every asynchronous operation.

- Active-hours and task-elapsed-time counters MUST update in
  real-time with no perceptible lag, satisfying SC-002 and SC-004
  (updates within 500 ms of user action).
- A loading skeleton or progress indicator MUST appear within 100 ms
  of initiating any data-fetching or submission operation (FR-005).
- Confirmation dialogs MUST follow a single, consistent pattern for
  task completion (FR-021), timesheet submission (FR-060), and
  logout (FR-113): title, descriptive body, primary action, and
  cancel action.
- Action buttons MUST be disabled and show a loading state during
  in-flight operations to prevent duplicate submissions.

### XX. Navigation & Information Architecture

Screen flows MUST align with the eight-module structure and guarantee
intuitive, lossless wayfinding throughout the application.

- A persistent bottom navigation bar MUST serve as primary navigation
  for the five main destinations (Dashboard, Tasks, Projects,
  Timesheet, and a More / Profile entry point); sub-modules are
  accessible from these roots.
- Deep-link navigation from notifications MUST open the relevant
  screen directly (e.g., timesheet reminder tap → Timesheet screen,
  FR-094); every notification type that links to a screen MUST have
  a defined deep-link route.
- Navigating back from any form with unsaved changes MUST present a
  save / discard confirmation; silent data loss on back-navigation
  is forbidden.
- Screen hierarchy depth MUST NOT exceed three levels from any
  bottom-nav destination; deeper flows MUST be redesigned or
  surfaced via modal sheets rather than full-page navigation.

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
  all twenty principles before Phase 0 research begins. Developer
  Principles XI–XV (architecture, state management, security) and
  UI/UX Principles XVI–XX (platform guidelines, accessibility,
  design system) MUST be addressed in the plan.
- **Gate 3 — Design Review**: A shared component library, color
  palette, typography scale, and navigation structure MUST be
  approved (UI/UX Principles XVIII & XX) before any module screen
  implementation begins.
- **Gate 4 — Test Readiness**: Failing test stubs for the current
  story MUST exist before implementation starts (QA Principle VI).
  Security checklist (Developer Principle XIII) MUST be verified.
- **Gate 5 — PR Approval**: Full test suite MUST pass; `flutter
  analyze` clean; acceptance tests for the story's FR-* requirements
  MUST be green; accessibility labels and touch targets verified
  (UI/UX Principle XVII). At least one reviewer MUST verify
  compliance with this constitution.
- **Gate 6 — Story Completion**: Acceptance criteria verified, no
  open critical/high defects, cross-platform smoke tests passed,
  and UI/UX consistency review signed off against the design system.

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
  the applicable BA (I–V), QA (VI–X), Developer (XI–XV), and UI/UX
  (XVI–XX) principles. Non-compliance MUST be resolved before merge.
- **Complexity Justification**: Any deviation from simplicity (extra
  abstractions, additional modules beyond the eight defined) MUST be
  justified in writing and approved via the amendment process.

**Version**: 1.0.0 | **Ratified**: 2026-03-12 | **Last Amended**: 2026-03-12