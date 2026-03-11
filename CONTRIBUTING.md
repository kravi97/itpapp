# Contributing to itpapp

Thank you for your interest in contributing to itpapp! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please be respectful and constructive in all interactions with other contributors.

## How to Contribute

### Reporting Bugs

Before creating a bug report, check the issue list to avoid duplicates.

**When filing a bug report, include:**
- Clear, descriptive title
- Description of the exact steps to reproduce
- Specific examples to demonstrate the steps
- Observed behavior and what you expected instead
- Screenshots if applicable
- Your environment (Flutter version, Dart version, OS, device)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues.

**When suggesting an enhancement, include:**
- Clear, descriptive title
- Step-by-step description of the suggested enhancement
- Examples showing how it would work
- Why this would be useful
- Possible implementation approaches (optional)

### Pull Requests

1. **Fork the repository** and clone it locally
2. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes:**
   - Follow the code style (see below)
   - Write clear, descriptive commit messages
   - Add tests for new functionality
4. **Test thoroughly:**
   ```bash
   flutter test
   flutter analyze
   dart format .
   ```
5. **Push to your fork:**
   ```bash
   git push origin feature/amazing-feature
   ```
6. **Open a Pull Request:**
   - Use a clear, descriptive title
   - Reference any related issues (e.g., "Closes #123")
   - Describe your changes and why they're needed
   - Include any breaking changes clearly

## Development Guidelines

### Code Style

Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide:

- Use 2-space indentation
- Use meaningful variable and function names
- Write comments for complex logic
- Follow the [Dart naming conventions](https://dart.dev/guides/language/effective-dart/style#naming-conventions)

### Code Quality

Before submitting a PR:

1. **Run analysis:**
   ```bash
   flutter analyze
   ```

2. **Format code:**
   ```bash
   dart format .
   ```

3. **Run tests:**
   ```bash
   flutter test
   ```

### Commit Messages

Write clear, descriptive commit messages:

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters
- Reference issues and pull requests liberally after the first line

Example:
```
Add user authentication feature

- Implement login screen
- Add Firebase authentication
- Add user model

Closes #123
```

### Documentation

- Update README.md if you change functionality
- Add comments to explain complex code
- Update this CONTRIBUTING.md if you change the process
- Include code examples where helpful

## Testing

- Write tests for new features
- Ensure all tests pass before submitting a PR
- Test on multiple platforms when possible
- Include both unit tests and integration tests where appropriate

## Review Process

1. At least one maintainer will review your PR
2. Changes may be requested before merging
3. Once approved, your changes will be merged to main

## Questions?

Feel free to open an issue with the question tag or reach out to the maintainers.

---

Thank you for contributing to itpapp! 🎉
