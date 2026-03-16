# Developer Guide

## Getting Started

### Prerequisites
- Flutter SDK 3.11.0 or higher
- Dart SDK 3.11.0 or higher
- Android Studio or VS Code with Flutter extension
- Xcode (for iOS development)
- Firebase account
- Git version control

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd accident_detection_system
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required files**
   ```bash
   flutter pub global activate intl_utils
   flutter pub run intl_utils:generate
   ```

## Project Structure

```
lib/
  ├── main.dart                 # App entry point
  ├── models/                   # Data models
  │   ├── user_model.dart
  │   ├── emergency_contact_model.dart
  │   └── accident_report_model.dart
  ├── services/                 # Business logic
  │   ├── auth_service.dart
  │   ├── sensor_monitoring_service.dart
  │   ├── location_service.dart
  │   ├── database_service.dart
  │   └── notification_service.dart
  ├── screens/                  # UI screens
  │   ├── auth/
  │   │   ├── login_screen.dart
  │   │   └── signup_screen.dart
  │   ├── dashboard/
  │   │   └── home_screen.dart
  │   ├── contacts/
  │   │   └── emergency_contacts_screen.dart
  │   ├── history/
  │   │   └── accident_history_screen.dart
  │   └── settings/
  │       └── settings_screen.dart
  └── utils/                    # Utilities
      ├── app_theme.dart
      ├── app_config.dart
      ├── constants.dart
      ├── validators.dart
      ├── formatters.dart
      ├── extensions.dart
      ├── custom_widgets.dart
      ├── dialogs.dart
      ├── navigation.dart
      ├── helpers.dart
      ├── logger.dart
      └── test_data.dart
```

## Code Standards

### Naming Conventions
- **Files**: snake_case (e.g., `auth_service.dart`)
- **Classes**: PascalCase (e.g., `AuthService`)
- **Variables**: camelCase (e.g., `isMonitoring`)
- **Constants**: camelCase (e.g., `impactThreshold`)
- **Private members**: camelCase with leading underscore (e.g., `_handleImpact()`)

### Code Style
- Use `const` constructors where possible
- Use `required` for mandatory parameters
- Document all public methods
- Use type annotations for variables
- Use null safety (non-nullable by default)
- Keep functions small (< 100 lines)
- Keep classes focused (single responsibility)

### Comments & Documentation
```dart
/// Brief description of the method.
///
/// Longer explanation if needed. Can span multiple lines.
///
/// Example:
/// ```dart
/// final result = await myFunction();
/// ```
Future<void> myFunction() async {
  // Implementation here
}
```

## Development Workflow

### 1. Feature Development

**Step 1: Create Feature Branch**
```bash
git checkout -b feature/description
```

**Step 2: Implement Feature**
- Create/modify necessary files
- Follow code standards
- Add documentation

**Step 3: Test Feature**
```bash
flutter test
flutter analyze
```

**Step 4: Commit Changes**
```bash
git add .
git commit -m "feat: add feature description"
```

**Step 5: Create Pull Request**
- Describe changes
- Reference issues
- Request reviews

### 2. Bug Fixes
```bash
git checkout -b fix/bug-description
# Implement fix
# Test thoroughly
git commit -m "fix: describe the fix"
```

### 3. Testing Requirements

**Unit Tests** (should test service methods)
```bash
flutter test test/services/auth_service_test.dart
```

**Widget Tests** (should test UI components)
```bash
flutter test test/widgets/custom_button_test.dart
```

**Integration Tests** (full app flow)
```bash
flutter test integration_test/scenario_test.dart
```

## Adding New Features

### Example: Adding a New Screen

**1. Create the screen file**
```dart
// lib/screens/new_feature/new_feature_screen.dart
class NewFeatureScreen extends StatefulWidget {
  const NewFeatureScreen({Key? key}) : super(key: key);

  @override
  State<NewFeatureScreen> createState() => _NewFeatureScreenState();
}

class _NewFeatureScreenState extends State<NewFeatureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Feature')),
      body: const Center(child: Text('Feature content')),
    );
  }
}
```

**2. Add route to navigation**
```dart
// lib/utils/navigation.dart
case AppRoutes.newFeature:
  return MaterialPageRoute(builder: (_) => const NewFeatureScreen());
```

**3. Add route constant**
```dart
// lib/utils/constants.dart
static const String newFeature = '/new-feature';
```

**4. Navigate to screen**
```dart
AppRouter.navigateTo(context, AppRoutes.newFeature);
```

## Working with Firebase

### Database Operations

**Adding data**
```dart
await _firestore.collection('users').doc(uid).set({
  'name': 'John',
  'email': 'john@example.com',
  'createdAt': FieldValue.serverTimestamp(),
});
```

**Reading data**
```dart
final doc = await _firestore.collection('users').doc(uid).get();
if (doc.exists) {
  final data = doc.data();
}
```

**Updating data**
```dart
await _firestore.collection('users').doc(uid).update({
  'name': 'Jane',
});
```

**Listening to changes**
```dart
_firestore.collection('users').doc(uid).snapshots().listen((doc) {
  // Handle changes
});
```

## Debugging

### Logging
```dart
// Debug log
Logger.debug('Debug message');

// Info log
Logger.info('Info message');

// Warning log
Logger.warning('Warning message');

// Error log
Logger.error('Error message', error, stackTrace);
```

### Common Issues

**Issue**: App crashes on startup
**Solution**: Check Firebase configuration, verify google-services.json exists

**Issue**: Sensors not working
**Solution**: Verify permissions granted, check device supports sensors

**Issue**: Location always null
**Solution**: Enable location services, grant permission, check GPS accuracy

**Issue**: Firebase operations fail
**Solution**: Check internet connection, verify Firestore rules, check collection names

## Performance Optimization

### Best Practices
1. **Minimize rebuilds**: Use `const` widgets and `StreamBuilder`
2. **Cache data**: Store in local variables when possible
3. **Lazy load**: Load data only when needed
4. **Batch operations**: Combine multiple writes
5. **Use indexes**: Create Firestore indexes for queries
6. **Optimize images**: Use appropriate sizes
7. **Debounce input**: Prevent rapid repeated calls

### Profiling
```bash
# Run with profiling
flutter run --profile

# Use DevTools memory profiler
flutter pub global activate devtools
devtools
```

## Version Management

### Semantic Versioning
- MAJOR.MINOR.PATCH
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

### Update Version
```yaml
# pubspec.yaml
version: 1.0.0+1
```

## Deployment

### Build APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-app.apk
```

### Build IPA
```bash
flutter build ios --release
# Output: build/ios/ipa/
```

### Upload to Stores
- Follow store-specific guidelines
- Ensure all requirements met
- Prepare screenshots and descriptions

## Useful Commands

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Analyze code
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test

# Run on specific device
flutter run -d <device-id>

# Build web (if enabled)
flutter build web

# Hot reload
R key in iOS simulator
r key in Android emulator
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Material Design](https://material.io/design)

## Support

For questions or issues:
1. Check documentation
2. Search existing issues
3. Open new issue with details
4. Include logs and error messages
