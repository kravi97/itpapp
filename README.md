# itpapp

A new Flutter project.

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the App](#running-the-app)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [Troubleshooting](#troubleshooting)

## Getting Started

This is a Flutter application that works on multiple platforms including iOS, Android, web, Linux, macOS, and Windows.

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (version 3.11.1 or higher)
   - [Install Flutter](https://flutter.dev/docs/get-started/install)

2. **Dart SDK** (comes with Flutter)
   - Version 3.11.1+

3. **Platform-specific requirements:**
   - **Android**: Android Studio, Android SDK (API level 21+)
   - **iOS**: Xcode 13.0+, CocoaPods
   - **macOS**: Xcode 13.0+
   - **Windows**: Visual Studio 2019+ or Build Tools
   - **Linux**: Build essentials, GTK development libraries
   - **Web**: Chrome or any modern browser

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/itpapp.git
   cd itpapp
   ```

2. **Get Flutter packages:**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup:**
   ```bash
   flutter doctor
   ```
   Ensure all required dependencies are installed.

## Running the App

### Debug Mode
```bash
# Run on default device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Release Mode
```bash
# For iOS
flutter run --release

# For Android
flutter build apk --release

# For Web
flutter build web --release

# For Windows
flutter build windows --release

# For macOS
flutter build macos --release

# For Linux
flutter build linux --release
```

### Hot Reload
During development, Flutter supports hot reload:
```bash
# After making changes, press 'r' in the terminal to hot reload
# Press 'R' to perform a hot restart
```

## Project Structure

```
itpapp/
├── lib/
│   └── main.dart           # Entry point of the application
├── android/                # Android-specific code
├── ios/                    # iOS-specific code
├── web/                    # Web-specific code
├── windows/                # Windows-specific code
├── macos/                  # macOS-specific code
├── linux/                  # Linux-specific code
├── pubspec.yaml            # Project dependencies
├── pubspec.lock            # Locked dependency versions
├── analysis_options.yaml   # Dart analysis rules
└── README.md               # This file
```

## Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Commit with clear messages:**
   ```bash
   git commit -m "Add feature: description"
   ```
5. **Push to your fork:**
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Open a Pull Request** with a description of your changes

### Code Style
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Run `flutter analyze` to check code quality
- Format code using `dart format .`

## Troubleshooting

### Common Issues

**Flutter doctor shows missing dependencies:**
```bash
flutter doctor --verbose
flutter pub get
```

**Build cache issues:**
```bash
flutter clean
flutter pub get
flutter run
```

**Plugin conflicts:**
```bash
rm -rf pubspec.lock
flutter pub get
```

**iOS build issues:**
```bash
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter clean
flutter pub get
flutter run
```

**Android build issues:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Getting Help

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [GitHub Issues](https://github.com/yourusername/itpapp/issues)

---

**Version:** 0.1.0  
**Flutter Version:** 3.11.1+
