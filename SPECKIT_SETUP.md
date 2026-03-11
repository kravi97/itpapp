# Speckit Setup & Usage Guide

This project integrates **Speckit**, a powerful tool for structured development planning, specification management, and collaborative task organization.

## What is Speckit?

Speckit helps you:
- Define clear project specifications
- Create structured implementation plans
- Organize development tasks with proper dependencies
- Maintain design artifacts and decision logs
- Collaborate with team members on project structure

## Installation

### Prerequisites

- **Node.js** 16.0.0 or higher ([Download Node.js](https://nodejs.org/))
- **npm** (comes with Node.js) or **yarn/pnpm**

### Install Speckit

```bash
# Using npm (recommended)
npm install -g speckit

# Using yarn
yarn global add speckit

# Using pnpm
pnpm add -g speckit
```

### Verify Installation

```bash
speckit --version
speckit doctor
```

If installation fails, try:
```bash
npm install -g speckit@latest
```

## Project Structure

Speckit-related files in this project:

```
.github/
├── agents/                 # Custom AI agent definitions
│   └── *.md               # Agent configuration files
└── prompts/               # Prompt templates for Speckit
    └── *.md               # Prompt template files

.specify/
├── spec.md                # Project specification
├── plan.md                # Implementation plan
├── tasks.md               # Organized task list
└── Other Speckit data files
```

## Common Speckit Commands

### Project Status
```bash
# Check project status and validate files
speckit check
```

### Creating Specifications

```bash
# Interactive specification creation
speckit specify "Your feature description"

# Review and update existing specifications
speckit specify --update
```

### Planning & Implementation

```bash
# Create an implementation plan
speckit plan

# Generate tasks from the plan
speckit tasks

# Start work on an issue
speckit start-work <issue-url>

# Create a pull request review
speckit start-review <pr-url>
```

### Task Management

```bash
# View all tasks
speckit tasks

# View task status
speckit check

# Organize tasks into groups
speckit tasks --organize
```

### Agents & Automation

```bash
# List available agents
speckit agents list

# Run a custom agent
speckit <agent-name>

# Available custom agents in this project:
# - speckit.analyze    - Analyze consistency across artifacts
# - speckit.checklist  - Generate feature checklists
# - speckit.clarify    - Clarify underspecified areas
# - speckit.constitution - Define project principles
# - speckit.implement  - Execute implementation plan
# - speckit.plan       - Create implementation plan
# - speckit.specify    - Define feature specifications
# - speckit.tasks      - Generate task lists
# - speckit.taskstoissues - Convert tasks to GitHub issues
```

## Workflow Example

### 1. Define a Feature
```bash
speckit specify "Add user authentication with Firebase"
```
This creates a detailed specification in `.specify/spec.md`

### 2. Create a Plan
```bash
speckit plan
```
Generates design artifacts and an implementation plan in `.specify/plan.md`

### 3. Generate Tasks
```bash
speckit tasks
```
Creates organized, dependency-ordered tasks in `.specify/tasks.md`

### 4. Review & Validate
```bash
speckit check
```
Ensures all artifacts are consistent and complete

### 5. Convert to GitHub Issues
```bash
speckit taskstoissues --repo <your-repo>
```
Automatically creates issues from tasks

## Project-Specific Agents

### Custom Agents Available

- **speckit.analyze** - Cross-artifact consistency analysis
- **speckit.checklist** - Generate custom feature checklists
- **speckit.clarify** - Identify and resolve underspecified areas
- **speckit.constitution** - Define project principles and standards
- **speckit.implement** - Execute the implementation plan autonomously
- **speckit.plan** - Generate detailed implementation planning
- **speckit.specify** - Create detailed specifications
- **speckit.tasks** - Generate actionable task lists
- **speckit.taskstoissues** - Convert tasks to GitHub issues

### Use Custom Agents

```bash
# Example: Generate a task checklist
speckit speckit.checklist

# Example: Analyze project consistency
speckit speckit.analyze

# Example: Start work on an issue
speckit speckit.implement
```

## File Descriptions

### .specify/spec.md
**Project Specification Document**
- Detailed feature descriptions
- Acceptance criteria
- Non-functional requirements
- Assumptions and constraints

### .specify/plan.md
**Implementation Plan**
- Design decisions
- Architecture overview
- Component breakdown
- Technology choices

### .specify/tasks.md
**Task Organization**
- Actionable tasks with clear descriptions
- Dependency relationships
- Estimated effort
- Assignee info
- Priority levels

## Tips & Best Practices

### 1. Keep Specifications Updated
```bash
# Before starting work
speckit check
```

### 2. Use Meaningful Titles
Create clear, descriptive specifications that capture the essence of features:
```bash
speckit specify "Implement multi-language support with i18n"
```

### 3. Involve the Team
Let Speckit help facilitate discussions:
```bash
# Clarify ambiguous requirements
speckit speckit.clarify

# Get team feedback on plans
speckit check
```

### 4. Automate with Agents
Use agents to handle repetitive work:
```bash
# Automatically implement clear, well-defined tasks
speckit speckit.implement
```

### 5. Maintain Consistency
```bash
# Ensure all documents align
speckit speckit.analyze
```

## Troubleshooting

### Speckit command not found
```bash
# Reinstall globally
npm install -g speckit@latest

# Or check if npm is in PATH
which npm
npm list -g speckit
```

### Permission denied error
```bash
# Use sudo (not recommended)
sudo npm install -g speckit

# Or fix npm permissions
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
```

### Issues with .specify directory
```bash
# Reset Speckit state
rm -rf .specify/
speckit check  # Recreates directory
```

### Out of date specifications
```bash
# Update all artifacts
speckit specify --update
speckit plan
speckit tasks
```

## Skipping Speckit

If you prefer not to use Speckit:

1. **It's optional** - The Flutter app works without it
2. **Skip installation** - Just don't run `npm install -g speckit`
3. **Normal workflow** - Use standard git/GitHub workflow
4. **Keep files** - The `.specify/` and `.github/` folders won't interfere

## Getting Help

- [Speckit Documentation](https://speckit.ai)
- [GitHub Issues](https://github.com/yourusername/itpapp/issues)
- Run `speckit --help` for command reference

## Integration with GitHub

Speckit integrates with GitHub for:
- Automatically creating issues from tasks
- Starting work with issue links
- Creating and reviewing pull requests
- Streaming AI feedback and reviews

```bash
# Create GitHub issues from tasks
speckit taskstoissues --repo username/itpapp

# Start work on an issue
speckit start-work https://github.com/username/itpapp/issues/123

# Review a pull request
speckit start-review https://github.com/username/itpapp/pull/456
```

---

**Version:** 0.1.0  
**Last Updated:** March 2026
