import 'package:flutter/material.dart';

/// App Constants
class AppConstants {
  // App Name and Version
  static const String appName = 'Smart Event Check-in';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Efficient crowd management and check-in solution';

  // Hive Box Names
  static const String eventBoxName = 'events';
  static const String checkInBoxName = 'checkins';
  static const String participantBoxName = 'participants';

  // Hive Type IDs
  static const int eventTypeId = 0;
  static const int participantTypeId = 1;
  static const int checkInTypeId = 2;

  // Timing
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration loadingDelay = Duration(milliseconds: 300);
  static const Duration syncCheckInterval = Duration(seconds: 30);

  // Validation Rules
  static const int minEventNameLength = 3;
  static const int maxEventNameLength = 100;
  static const int minCapacity = 1;
  static const int maxCapacity = 100000;
  static const int minParticipantIdLength = 2;
  static const int maxParticipantIdLength = 50;

  // UI Dimensions
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Messages
  static const Map<String, String> messages = {
    'eventCreated': 'Event created successfully!',
    'eventDeleted': 'Event deleted successfully!',
    'checkedInSuccess': 'Participant checked in successfully!',
    'duplicateCheckIn': '⚠️ Duplicate entry detected! Participant already checked in.',
    'capacityFull': 'Event is at full capacity!',
    'noEventSelected': 'Please select an event first',
    'invalidQRCode': 'Invalid QR code',
    'offlineMode': 'Offline Mode - Data will sync when online',
    'syncedSuccessfully': 'Data synced successfully',
  };

  // Regex Patterns
  static const String participantIdPattern = r'^[a-zA-Z0-9_\-]+$';
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9+\-\s()]+$';
}

/// App Colors
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF42A5F5);

  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Crowd Level Colors
  static const Color crowdEmpty = Color(0xFFEBEBEB);
  static const Color crowdSafe = Color(0xFF4CAF50);
  static const Color crowdModerate = Color(0xFFFFA726);
  static const Color crowdCrowded = Color(0xFFFF7043);
  static const Color crowdFull = Color(0xFFF44336);

  // Neutral Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Offline Mode
  static const Color offlineBackground = Color(0xFFFFA726);
}

/// App Text Styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
  );
}

/// Crowd Level Constants
class CrowdLevelConstants {
  static const String levelEmpty = 'Empty';
  static const String levelSafe = 'Safe';
  static const String levelModerate = 'Moderate';
  static const String levelCrowded = 'Crowded';
  static const String levelFull = 'Full';

  static const String iconEmpty = '⭕';
  static const String iconSafe = '🟢';
  static const String iconModerate = '🟡';
  static const String iconCrowded = '🟠';
  static const String iconFull = '🔴';
}

/// Route Names
class RouteNames {
  static const String setup = '/setup';
  static const String checkin = '/checkin';
  static const String dashboard = '/dashboard';
  static const String logs = '/logs';
}
