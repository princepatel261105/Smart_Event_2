# Implementation Details & Technical Architecture

## Project Overview

**Smart Event Check-in & Crowd Management App** is a complete Flutter application designed to digitize event participant check-ins with offline-first capabilities.

## Architecture Overview

### Layered Architecture
```
┌─────────────────────────────────┐
│         UI Layer (Screens)      │
├─────────────────────────────────┤
│       State Management (Provider)│
├─────────────────────────────────┤
│      Data Layer (Hive Storage)  │
└─────────────────────────────────┘
```

### Design Patterns Used

1. **Provider Pattern**: State management
2. **Repository Pattern**: Data access
3. **Factory Pattern**: Model creation
4. **Observer Pattern**: Reactive updates
5. **Adapter Pattern**: Hive type adapters

## Component Architecture

### 1. Models (Data Layer)

#### Event Model
```dart
- id: String (UUID)
- eventName: String
- eventDate: DateTime
- maxCapacity: int
- createdAt: DateTime
- isActive: bool
```

Hive Adapter: `EventAdapter (TypeId: 0)`

#### CheckInRecord Model
```dart
- id: String (UUID)
- eventId: String (Foreign Key)
- participantId: String
- participantName: String
- checkedInAt: DateTime
- isSynced: bool
- notes: String?
```

Hive Adapter: `CheckInRecordAdapter (TypeId: 2)`

#### Participant Model
```dart
- id: String (UUID)
- participantId: String
- name: String
- email: String?
- phone: String?
- eventId: String (Foreign Key)
- createdAt: DateTime
```

Hive Adapter: `ParticipantAdapter (TypeId: 1)`

### 2. Providers (State Management)

#### EventProvider
**Responsibilities:**
- Create, retrieve, delete events
- Manage current active event
- Get all events list
- Clear event data

**Key Methods:**
- `createEvent()` - Create new event
- `setCurrentEvent()` - Set active event
- `getEventById()` - Retrieve specific event
- `deleteEvent()` - Remove event
- `clearAllData()` - Reset all events

#### CheckInProvider
**Responsibilities:**
- Manage check-in records
- Detect duplicate entries
- Track capacity usage
- Provide search functionality
- Handle sync status

**Key Methods:**
- `checkInParticipant()` - Add check-in record
- `isDuplicateCheckIn()` - Validate entry
- `getEventCheckInCount()` - Get total check-ins
- `getEventCheckIns()` - Retrieve all check-ins for event
- `searchParticipant()` - Search by ID/name
- `getUnsyncedCheckIns()` - Get offline records

#### ParticipantProvider
**Responsibilities:**
- Manage participant data
- Validate participant existence
- Store participant details
- Retrieve participants by event

**Key Methods:**
- `addParticipant()` - Add new participant
- `participantExists()` - Check existence
- `getParticipant()` - Retrieve specific participant
- `getEventParticipants()` - Get all participants

#### ConnectivityProvider
**Responsibilities:**
- Monitor network connectivity
- Provide connection status
- Emit updates on connectivity change
- Show offline indicator

**Key Methods:**
- `initialize()` - Start monitoring
- `get isConnected()` - Get current status
- `get statusText()` - Human-readable status

### 3. Screens (UI Layer)

#### DashboardScreen
**Purpose**: Home screen showing all events with crowd status
**Features**:
- List of all events
- Crowd level visualization
- Quick statistics
- Event actions menu
- Create new event FAB

**Navigation**:
- Tap event → Go to check-in
- Tap "Check In" button → Check-in screen
- Tap FAB → Create event

#### EventSetupScreen
**Purpose**: Create new events
**Features**:
- Event name input
- Date picker
- Time picker
- Capacity input
- Form validation
- Success navigation

**Validation**:
- Event name: 3+ characters
- Capacity: 1-100,000

#### CheckInScreen
**Purpose**: Participant check-in (QR + Manual)
**Features**:
- QR code scanner (Tab 1)
- Manual entry form (Tab 2)
- Real-time detection
- Duplicate prevention
- Capacity checking
- Success/Error feedback

**QR Tab**:
- Camera stream
- Real-time detection
- Tips display
- Auto-dismiss after check-in

**Manual Tab**:
- Participant ID field (required)
- Participant name field (optional)
- Submit button
- Input validation

#### LogsSearchScreen
**Purpose**: View and search check-in records
**Features**:
- Search by ID or name
- Complete check-in history
- QR code generation
- Data export (CSV)
- Time formatting
- Record details

**Search**:
- Real-time filtering
- Match ID or name
- Display matching records

**Actions**:
- View QR code
- View details
- Export all data

### 4. Widgets (Reusable Components)

#### Custom Buttons
- `PrimaryButton`: Main action buttons
- `SecondaryButton`: Secondary actions
- Features: Loading states, icons, custom colors

#### Custom TextField
- Labeled input with validation
- Focus state styling
- Icon support
- Error display

#### Custom Dialogs
- `showCustomSnackBar()`: Toast notifications
- `showCustomDialog()`: Alert dialogs
- Type: success, error, warning, info

#### Custom Cards
- `ConnectivityBanner`: Offline status
- `CrowdLevelCard`: Crowd visualization
- `StatisticCard`: Statistics display

### 5. Utilities

#### DateTime Utils
- Format dates/times
- "Time ago" formatting
- Consistent date display

#### Validation Utils
- Participant ID validation
- Event name validation
- Email/Phone validation
- Custom error messages

#### Crowd Level Utils
- Calculate crowd percentage
- Get crowd level text
- Get level color
- Get emoji indicator

## Feature Implementation

### QR Code Scanning

**Technology**: `mobile_scanner` plugin

**Flow**:
1. Camera initialized on screen load
2. BarcodeCapture event fires
3. Extract barcode raw value
4. Validate QR code
5. Process check-in
6. Show feedback

**Handling**:
- Prevent duplicate scans (1-second delay)
- Handle empty QR codes
- Validate participant ID
- Check for duplicates

### Duplicate Prevention

**Algorithm**:
```
if checkIn exists for (eventId, participantId):
    return "Duplicate"
else:
    create checkIn
    return "Success"
```

**Storage**: Checked against all local check-in records

### Capacity Management

**Check**:
```
if checkedInCount >= maxCapacity:
    return "Full"
else:
    proceed with check-in
```

**Display**: Remaining capacity = maxCapacity - checkedInCount

### Offline Functionality

**Data Flow**:
1. User performs action
2. Data saved to local Hive box
3. If online: Immediate sync
4. If offline: Mark as unsynced
5. When connection restored: Auto-sync

**Status**:
- `isSynced = false`: Pending sync
- `isSynced = true`: Synced to cloud (future)

### Search Implementation

**Algorithm**:
```
for each checkIn in eventCheckIns:
    if participantId.contains(query) OR name.contains(query):
        add to results
return results
```

**Features**:
- Case-insensitive
- Partial matches
- Real-time filtering

## Data Persistence

### Hive Setup

**Initialization**:
```dart
await Hive.initFlutter()
Hive.registerAdapter(EventAdapter())
Hive.registerAdapter(ParticipantAdapter())
Hive.registerAdapter(CheckInRecordAdapter())
```

**Boxes**:
- `events`: Event objects
- `checkins`: CheckInRecord objects
- `participants`: Participant objects

**Storage Location**:
- iOS: `Documents/hive_db/`
- Android: `/data/data/com.example.smart_event/hive_db/`

### Data Access Pattern

```dart
// Opening box
final box = await Hive.openBox<Event>('events');

// Saving
await box.add(event);

// Reading
final events = box.values.toList();

// Updating
event.eventName = 'New Name';
await event.save();

// Deleting
await box.deleteAt(index);
```

## State Management Flow

### Single Event Lifecycle

```
User Input
    ↓
Controller (Screen)
    ↓
Provider Method
    ↓
Hive Box Operation
    ↓
ChangeNotifier emit
    ↓
UI Update
    ↓
Screen Rebuild
```

### Multi-Provider Updates

```
Event Created
    ↓
EventProvider.createEvent()
    ↓
Hive Save
    ↓
NotifyListeners
    ↓
DashboardScreen Rebuilds
    ↓
CheckInProvider Updated
```

## Error Handling Strategy

### Input Validation
- Check before database operation
- Show specific error message
- Highlight invalid field

### Business Logic Errors
- Duplicate check-in
- Capacity exceeded
- Invalid QR code
- Missing event

### Runtime Errors
- Try-catch blocks
- Log to console
- Show user-friendly message
- Fallback actions

### Network Errors
- Detect connection change
- Save offline
- Show offline banner
- Sync when available

## Performance Optimizations

### Memory
- Lazy load event list
- Dispose controllers properly
- Clear search results
- Limit history display

### UI
- Use `const` constructors
- Avoid rebuilds of unchanged widgets
- Tab view lazy loading
- Image caching

### Database
- Index queries efficiently
- Batch operations where possible
- Archive old events
- Periodic cleanup

## Security Considerations

### Data Validation
- Sanitize user input
- Validate QR codes
- Check data types
- Verify timestamps

### Access Control
- Basic event-based access
- No user authentication (future)
- Data isolated by event
- Local storage only (no exposure)

### Future Cloud Features
- HTTPS for API calls
- Token-based authentication
- Encryption for sensitive data
- API rate limiting

## Testing Recommendations

### Unit Tests
- Validation functions
- Crowd level calculations
- DateTime formatting
- Search algorithms

### Widget Tests
- Custom widgets render
- Button interactions
- Form validation
- Error display

### Integration Tests
- Create event flow
- Check-in flow
- Search flow
- Offline sync flow

## Build & Release

### Debug Build
```bash
flutter run
```

### Release Build
```bash
flutter build apk --release
flutter build ios --release
```

### Version Management
- Update pubspec.yaml
- Tag release on GitHub
- Update changelog
- Announce features

## Future Enhancements

### Phase 2: Cloud Integration
- Firebase Firestore sync
- REST API integration
- Cloud backup
- Analytics

### Phase 3: Advanced Features
- Email notifications
- SMS alerts
- Real-time graphs
- Multi-event analytics

### Phase 4: Mobile Features
- Biometric authentication
- Barcode scanning
- Photo check-in
- Voice commands

### Phase 5: Admin Dashboard
- Web dashboard
- Event analytics
- User management
- Report generation
