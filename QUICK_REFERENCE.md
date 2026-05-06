# Quick Reference Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Install Dependencies
```bash
cd c:\Users\Prince Patel\OneDrive\Desktop\Smart Event\smart_event
flutter pub get
```

### Step 2: Generate Hive Adapters (IMPORTANT!)
```bash
flutter pub run build_runner build
```

### Step 3: Run the App
```bash
flutter run
```

---

## 📱 App Navigation

```
Dashboard Screen (Home)
    ↓
    ├→ Create Event (Event Setup Screen)
    │   └→ Check-in Screen
    │
    ├→ Check In Participants (Check-in Screen)
    │   ├→ QR Scan Tab
    │   └→ Manual Entry Tab
    │
    └→ View Logs & Search (Logs Screen)
        ├→ Search Records
        ├→ View QR Code
        └→ Export Data
```

---

## 🎯 Key Features at a Glance

| Feature | Location | How to Use |
|---------|----------|-----------|
| Create Event | Dashboard FAB | Tap + button |
| QR Check-in | Check-in Tab 1 | Point camera at QR |
| Manual Check-in | Check-in Tab 2 | Enter Participant ID |
| View Crowd Status | Dashboard | See card with indicators |
| Search Check-ins | Logs Screen | Type in search box |
| Export Data | Logs Screen | Tap download icon |
| View Offline Status | Any screen | Check banner at top |

---

## 💻 Development Commands

```bash
# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Clean build
flutter clean

# Run app
flutter run

# Run with verbose output
flutter run -v

# Build APK (release)
flutter build apk --release

# Run on specific device
flutter run -d <device-id>
```

---

## 📂 Important File Locations

```
lib/
├── main.dart                    ← App entry point
├── constants.dart               ← App colors, strings, constants
├── models/                      ← Data structures
│   ├── event_model.dart
│   ├── participant_model.dart
│   └── checkin_model.dart
├── providers/                   ← State management
│   ├── event_provider.dart
│   ├── checkin_provider.dart
│   └── connectivity_provider.dart
├── screens/                     ← Main screens
│   ├── dashboard_screen.dart
│   ├── event_setup_screen.dart
│   ├── checkin_screen.dart
│   └── logs_search_screen.dart
├── widgets/                     ← Reusable components
│   ├── custom_buttons.dart
│   ├── custom_textfield.dart
│   ├── custom_dialogs.dart
│   └── custom_cards.dart
└── utils/                       ← Helper functions
    ├── datetime_utils.dart
    ├── validation_utils.dart
    └── crowd_level_utils.dart
```

---

## 🔍 Useful Code Snippets

### Access Event Provider
```dart
final eventProvider = context.read<EventProvider>();
final event = eventProvider.currentEvent;
```

### Check-in Participant
```dart
final checkInProvider = context.read<CheckInProvider>();
await checkInProvider.checkInParticipant(
  eventId: event.id,
  participantId: 'PART001',
  participantName: 'John Doe',
);
```

### Check for Duplicates
```dart
if (checkInProvider.isDuplicateCheckIn(eventId, participantId)) {
  // Show error
}
```

### Search Participants
```dart
final results = checkInProvider.searchParticipant(eventId, 'PART');
```

### Check Connectivity
```dart
final connectivity = context.watch<ConnectivityProvider>();
if (connectivity.isConnected) {
  // Online
} else {
  // Offline
}
```

---

## 🧪 Quick Testing Checklist

- [ ] Create an event with small capacity (e.g., 5)
- [ ] Check in 5 participants
- [ ] Try checking in duplicate (should fail)
- [ ] Try checking in when full (should fail)
- [ ] Search for participant by ID
- [ ] Search for participant by name
- [ ] Export data
- [ ] Turn off internet, try check-in (should work)
- [ ] Turn on internet (data should persist)

---

## 📱 Platform Permissions

### Android
- **Camera**: Required for QR scanning
- **Network**: Required for connectivity check

### iOS
- **Camera**: NSCameraUsageDescription in Info.plist
- **Network**: NSLocalNetworkUsageDescription

---

## 🐛 Common Issues & Solutions

### Issue: "Hive box not open"
**Solution**: Run `flutter pub run build_runner build`

### Issue: "Camera permission denied"
**Android**: Check AndroidManifest.xml has camera permission
**iOS**: Add NSCameraUsageDescription to Info.plist

### Issue: "QR code not detected"
- Ensure good lighting
- Keep camera steady
- QR code must be fully visible

### Issue: "App crashes on startup"
- Run: `flutter clean`
- Run: `flutter pub get`
- Run: `flutter pub run build_runner build`
- Run: `flutter run`

---

## 📝 Documentation Files

| File | Purpose |
|------|---------|
| README.md | Project overview |
| README_DETAILED.md | Detailed features |
| SETUP_GUIDE.md | Installation & config |
| IMPLEMENTATION_DETAILS.md | Technical design |
| SUBMISSION_GUIDE.md | Submission checklist |
| PROJECT_COMPLETION_SUMMARY.md | Project summary |
| QUICK_REFERENCE.md | This file |

---

## 🎯 GitHub Setup

### Initial Setup
```bash
git init
git add .
git commit -m "Initial project setup and dependencies"
git remote add origin <repository-url>
git push -u origin main
```

### Subsequent Commits
```bash
# After UI work
git add .
git commit -m "Implement all screens and reusable widgets"
git push

# After features
git add .
git commit -m "Implement core features and providers"
git push

# After polish
git add .
git commit -m "Add offline functionality and final enhancements"
git push
```

---

## 📊 Data Storage

### Hive Boxes
- **events**: Event objects
- **checkins**: CheckInRecord objects
- **participants**: Participant objects

### Access Data
```dart
final eventsBox = Hive.box<Event>('events');
final events = eventsBox.values.toList();
```

### Clear All Data (Use Carefully!)
```dart
await Hive.box('events').clear();
await Hive.box('checkins').clear();
await Hive.box('participants').clear();
```

---

## 🎨 Customization

### Change Primary Color
```dart
// In main.dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue,  // Change this
),
```

### Change App Name
```dart
// In constants.dart
static const String appName = 'Your App Name';
```

### Add New Validation
```dart
// In validation_utils.dart
static String? validateCustom(String? value) {
  if (value?.isEmpty ?? true) return 'Field required';
  return null;
}
```

---

## 📞 Support Resources

### Official Documentation
- [Flutter Docs](https://flutter.dev)
- [Dart Docs](https://dart.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [Hive Documentation](https://docs.hivedb.dev)

### Troubleshooting
1. Check error message carefully
2. Search on GitHub issues
3. Check StackOverflow
4. Review documentation

---

## ✅ Pre-Submission Checklist

- [ ] All features working
- [ ] Offline mode tested
- [ ] No compile errors
- [ ] All screens accessible
- [ ] Navigation working
- [ ] Data persists on restart
- [ ] Error messages clear
- [ ] Code well-organized
- [ ] Documentation complete
- [ ] GitHub commits done

---

## 🎓 Next Steps

1. **Install & Run**: Follow "Getting Started" section
2. **Test Features**: Use "Quick Testing Checklist"
3. **Customize**: Modify colors, strings, etc.
4. **Deploy**: Use GitHub setup commands
5. **Document**: Take screenshots for PDF
6. **Submit**: Create PDF with required info

---

**Version**: 1.0.0  
**Last Updated**: 2026  
**Status**: Ready for Production
