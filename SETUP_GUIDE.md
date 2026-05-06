# Configuration & Setup Guide

## Environment Setup

### 1. Flutter Installation
```bash
# Download Flutter SDK from flutter.dev
# Add to PATH environment variable
flutter doctor
```

### 2. Project Dependencies
```bash
cd smart_event
flutter pub get
```

### 3. Code Generation (Important!)
```bash
# Generate Hive adapters - MUST RUN ONCE
flutter pub run build_runner build

# For clean rebuild:
flutter pub run build_runner clean
flutter pub run build_runner build
```

### 4. Run the App
```bash
flutter run

# For specific device:
flutter run -d <device-id>

# For release mode:
flutter run --release
```

## Platform-Specific Setup

### Android Setup
- Android SDK 21+ required
- Configure android/local.properties
- Enable camera permission in AndroidManifest.xml

### iOS Setup
- iOS 11+ required
- Run: `cd ios && pod install && cd ..`
- Configure camera permission in Info.plist

## Database Initialization

Hive boxes are auto-created on first run:
- `events` - Event objects
- `checkins` - CheckInRecord objects  
- `participants` - Participant objects

Location: `/data/data/com.example.smart_event/hive_db/`

## API Configuration (Future)

When adding Firebase or REST API:
1. Create `lib/config/api_config.dart`
2. Add API endpoints and keys
3. Configure authentication
4. Setup sync manager

## Debugging

### Enable Verbose Logging
```bash
flutter run -v
```

### Debug Hive Database
```dart
// Print all boxes
print(Hive.box('events').values.toList());
```

### Hot Reload vs Hot Restart
- Hot Reload: Quick changes (not working with model changes)
- Hot Restart: Full restart (needed for Hive adapter changes)

## Troubleshooting

### Build Errors
```bash
# Clean everything
flutter clean
flutter pub get
flutter pub run build_runner build
```

### Hive Adapter Errors
- Run: `flutter pub run build_runner build`
- Check model files have `part` statements
- Verify adapter registrations in main.dart

### Camera Permission Issues
- iOS: Check Info.plist for camera permission
- Android: Check AndroidManifest.xml permissions
- Request runtime permissions on Android 6+

## Performance Optimization

1. **Build Release Version**
   ```bash
   flutter build apk --release
   ```

2. **Enable Tree Shaking**
   - Enabled by default in release mode

3. **Profile Performance**
   ```bash
   flutter run --profile
   ```

## Version Management

Current Versions:
- Flutter: 3.11+
- Dart: 3.0+
- Provider: 6.0
- Hive: 2.2

## Backup & Recovery

### Export Data
```dart
// Export all check-ins
final checkIns = checkInProvider.allCheckIns;
// Convert to JSON/CSV
```

### Clear Local Data (Use with caution!)
```dart
await eventProvider.clearAllData();
await checkInProvider.clearAllData();
```

## Production Checklist

- [ ] Test on physical devices
- [ ] Verify QR code scanning works
- [ ] Test offline functionality
- [ ] Check error messages are clear
- [ ] Verify data export works
- [ ] Test on low connectivity
- [ ] Release build passes
- [ ] Privacy policy added
- [ ] Version number updated
