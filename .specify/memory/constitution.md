<!--
  Sync Impact Report
  ==================
  Version change: 0.0.0 → 1.0.0 (MAJOR — initial constitution creation)
  Modified principles: N/A (initial version)
  Added sections:
    - Core Principles (BA): 5 principles covering requirements traceability,
      user-story-driven design, acceptance criteria, module boundaries, and
      stakeholder alignment
    - Core Principles (QA): 5 principles covering test-first validation,
      acceptance test coverage, regression safety, cross-platform testing,
      and defect lifecycle management
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
  all ten principles before Phase 0 research begins.
- **Gate 3 — Test Readiness**: Failing test stubs for the current
  story MUST exist before implementation starts (QA Principle VI).
- **Gate 4 — PR Approval**: Full test suite MUST pass; `flutter
  analyze` clean; acceptance tests for the story's FR-* requirements
  MUST be green. At least one reviewer MUST verify compliance with
  this constitution.
- **Gate 5 — Story Completion**: Acceptance criteria verified, no
  open critical/high defects, cross-platform smoke tests passed.

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
  the applicable BA and QA principles. Non-compliance MUST be
  resolved before merge.
- **Complexity Justification**: Any deviation from simplicity (extra
  abstractions, additional modules beyond the eight defined) MUST be
  justified in writing and approved via the amendment process.

**Version**: 1.0.0 | **Ratified**: 2026-03-12 | **Last Amended**: 2026-03-12