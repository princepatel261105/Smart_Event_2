# Smart Event Check-in & Crowd Management App

A Flutter-based mobile application for efficient participant check-in management with QR code scanning, real-time crowd monitoring, and offline-first functionality.

## 📱 Features

### ✅ Event Management
- Create events with custom name, date, time, and capacity
- View all events in a dashboard
- Edit and delete events
- Select active event for operations

### 📊 Participant Check-In
- **QR Code Scanning**: Fast check-in using QR codes
- **Manual Entry**: Check-in by entering Participant ID manually
- **Duplicate Prevention**: Prevents multiple check-ins for same participant
- **Capacity Enforcement**: Blocks check-in when event reaches full capacity
- **Real-time Feedback**: Instant confirmation or error messages

### 📈 Crowd Monitoring Dashboard
- **Real-time Statistics**: Shows checked-in vs. available spots
- **Crowd Level Indicators**: Visual indicators (Safe/Moderate/Crowded/Full)
- **Capacity Progress**: Visual progress bar showing occupancy percentage
- **Multiple Views**: Grid/List view of all events with metrics

### 🔍 Logs & Search
- Search participants by ID or name
- View complete check-in history
- Export data as CSV
- Generate QR codes for verification
- Time-based filtering

### 📴 Offline Functionality
- **Offline-First Design**: Works without internet connection
- **Local Storage**: All data stored locally using Hive
- **Automatic Sync**: Data syncs when connection restored
- **Sync Status**: Visual indicators showing sync state

### 🔔 Additional Features
- **Connectivity Monitor**: Shows online/offline status
- **Responsive UI**: Works seamlessly on phones and tablets
- **Intuitive Navigation**: Tab-based navigation between screens
- **Error Handling**: Comprehensive error messages and validation

## 🏗️ Project Structure

```
lib/
├── models/              # Data models with Hive adapters
│   ├── event_model.dart
│   ├── participant_model.dart
│   ├── checkin_model.dart
│   └── index.dart
├── providers/           # State management using Provider
│   ├── event_provider.dart
│   ├── checkin_provider.dart
│   ├── participant_provider.dart
│   ├── connectivity_provider.dart
│   └── index.dart
├── screens/             # UI Screens
│   ├── event_setup_screen.dart
│   ├── checkin_screen.dart
│   ├── dashboard_screen.dart
│   ├── logs_search_screen.dart
│   └── index.dart
├── widgets/             # Reusable UI components
│   ├── custom_buttons.dart
│   ├── custom_textfield.dart
│   ├── custom_dialogs.dart
│   ├── custom_cards.dart
│   └── index.dart
├── utils/               # Utility functions
│   ├── datetime_utils.dart
│   ├── validation_utils.dart
│   ├── crowd_level_utils.dart
│   └── index.dart
└── main.dart           # App entry point
```

## 🎨 Screens Overview

### 1. **Dashboard Screen** (Home)
- Displays all created events
- Shows crowd status for each event
- Quick access to check-in functionality
- Create new event button

### 2. **Event Setup Screen**
- Create new events
- Input event details (name, date, time, capacity)
- Form validation
- Navigate to check-in after creation

### 3. **Check-in Screen**
- **Tab 1: QR Code Scanner**
  - Camera-based QR code scanning
  - Real-time detection
  - Duplicate prevention
  - Capacity checking
  
- **Tab 2: Manual Entry**
  - Input participant ID
  - Optional name entry
  - Quick check-in validation
  - Keyboard-based entry

### 4. **Logs & Search Screen**
- Search check-ins by ID or name
- View complete check-in history
- Generate and display QR codes for verification
- Export data as CSV
- Timestamp display with "time ago" format

## 🛠️ Technical Stack

### Core Framework
- **Flutter 3.11+**: UI framework
- **Dart 3.0+**: Programming language

### State Management
- **Provider 6.0**: Reactive state management

### Local Storage
- **Hive 2.2**: NoSQL local database
- **Hive Flutter 1.1**: Flutter integration

### QR Code
- **mobile_scanner 4.0**: QR code scanning
- **qr_flutter 4.1**: QR code generation

### Other Dependencies
- **intl 0.19**: Date/time formatting
- **connectivity_plus 5.0**: Network connectivity monitoring
- **flutter_local_notifications 14.1**: Local notifications
- **uuid 4.0**: Unique identifier generation

## 📥 Installation & Setup

### Prerequisites
- Flutter SDK 3.11+
- Dart SDK 3.0+
- Android SDK (for Android) or Xcode (for iOS)

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd smart_event
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🚀 Usage Guide

### Creating an Event
1. Tap "Create Event" on Dashboard
2. Fill in event details:
   - Event Name (min 3 characters)
   - Date (select from calendar)
   - Time (select from time picker)
   - Maximum Capacity (number)
3. Tap "Create Event"
4. System automatically navigates to check-in screen

### Checking In Participants

**Via QR Code:**
1. Go to Check-in Screen
2. Select "QR Scan" tab
3. Point camera at QR code
4. System automatically checks in participant
5. Receive confirmation message

**Manual Entry:**
1. Go to Check-in Screen
2. Select "Manual Entry" tab
3. Enter Participant ID (required)
4. Enter Participant Name (optional)
5. Tap "Check In"
6. Receive confirmation

### Monitoring Crowd
1. Go to Dashboard
2. View each event's crowd status
3. Check crowd level indicator:
   - 🟢 Green (Safe): < 50% capacity
   - 🟡 Yellow (Moderate): 50-80% capacity
   - 🟠 Orange (Crowded): 80-100% capacity
   - 🔴 Red (Full): 100% capacity

### Searching Check-ins
1. Go to Logs & Search screen
2. Search by Participant ID or Name
3. View matching check-in records
4. Tap on record for more options:
   - View QR code
   - View check-in time

## 💾 Data Storage

### Hive Boxes
- **events**: Stores Event objects
- **checkins**: Stores CheckInRecord objects
- **participants**: Stores Participant objects

### Data Persistence
- All data automatically saved to device storage
- Data persists across app restarts
- Automatic cleanup when events are deleted

## 🔐 Error Handling & Validation

### Input Validation
- Participant ID: Alphanumeric and special characters
- Event Name: Minimum 3 characters
- Capacity: Positive integer, max 100,000
- Email: Valid email format (optional)
- Phone: Valid phone number (optional)

### Error Prevention
- Duplicate check-in detection
- Capacity enforcement
- Network connectivity check
- Input field validation

### User Feedback
- Success messages in green
- Error messages in red
- Warning messages in orange
- Information messages in blue

## 🔌 Offline Functionality

### How It Works
1. **Detection**: App monitors network connectivity
2. **Operation**: All data stored locally
3. **Sync**: When connection restored, unsync marked records sync
4. **Status**: Offline banner displays when disconnected

### Data Flow
- Participants check in → Data saved locally
- Connection restored → Sync indicator shows
- Data marked as synced → Ready for next operation

## 🎯 Future Enhancements

1. **Cloud Sync Integration**
   - Firebase Firestore integration
   - REST API integration
   - Cloud backup

2. **Advanced Features**
   - Email notifications
   - SMS alerts for capacity reached
   - Real-time crowd graphs
   - Multi-event comparison

3. **Admin Features**
   - Event templates
   - Bulk participant import
   - Advanced analytics
   - Permission-based access

4. **Mobile Platform Features**
   - Barcode scanning (in addition to QR)
   - Photo-based identification
   - Biometric check-in
   - Voice commands

5. **UI/UX Enhancements**
   - Dark mode support
   - Customizable themes
   - Accessibility improvements
   - Multiple language support

## 📊 Data Models

### Event
```dart
- id: String (UUID)
- eventName: String
- eventDate: DateTime
- maxCapacity: int
- createdAt: DateTime
- isActive: bool
```

### CheckInRecord
```dart
- id: String (UUID)
- eventId: String (FK)
- participantId: String
- participantName: String
- checkedInAt: DateTime
- isSynced: bool
- notes: String?
```

### Participant
```dart
- id: String (UUID)
- participantId: String
- name: String
- email: String?
- phone: String?
- eventId: String (FK)
- createdAt: DateTime
```

## 🧪 Testing

### Manual Testing Checklist
- [ ] Create event with various capacities
- [ ] Check-in participants via QR and manual entry
- [ ] Verify duplicate prevention
- [ ] Test capacity enforcement
- [ ] Search functionality
- [ ] Offline mode operation
- [ ] Data persistence after restart
- [ ] Export functionality

## 📄 GitHub Commits

### Commit 1: Project Initialization
```
commit: Initial project setup with Flutter structure
- Initialize Flutter project
- Configure pubspec.yaml with dependencies
- Setup Hive adapters and models
```

### Commit 2: UI Implementation
```
commit: Complete UI screens and widgets
- Create all 4 main screens
- Build custom widgets and components
- Implement responsive layouts
- Add themes and styling
```

### Commit 3: Core Functional Logic
```
commit: Implement core features
- Event management functionality
- QR code scanning
- Manual check-in
- Crowd monitoring
- Search and logs
```

### Commit 4: Offline Storage & Final Enhancements
```
commit: Offline support and refinements
- Hive local storage setup
- Offline-first data management
- Sync status tracking
- Error handling and validation
- Final UI polish
```

## 🤝 Contributing

When contributing, please:
1. Follow Flutter/Dart style guidelines
2. Add meaningful commit messages
3. Test changes before submitting
4. Update documentation as needed

## 📝 License

This project is open source and available under the MIT License.

## 👥 Support

For issues, questions, or suggestions:
1. Open a GitHub issue
2. Provide detailed description
3. Include device/environment details
4. Attach screenshots if applicable

---

**Built with ❤️ using Flutter**
