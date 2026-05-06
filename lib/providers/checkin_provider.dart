import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/index.dart';

class CheckInProvider extends ChangeNotifier {
  late Box<CheckInRecord> checkInBox;

  List<CheckInRecord> get allCheckIns {
    if (checkInBox.isEmpty) {
      return [];
    }
    return checkInBox.values.toList();
  }

  Future<void> initializeBox() async {
    if (!Hive.isBoxOpen('checkins')) {
      checkInBox = await Hive.openBox<CheckInRecord>('checkins');
    } else {
      checkInBox = Hive.box<CheckInRecord>('checkins');
    }
  }

  Future<bool> checkInParticipant({
    required String eventId,
    required String participantId,
    required String participantName,
  }) async {
    try {
      // Check for duplicate check-in
      if (isDuplicateCheckIn(eventId, participantId)) {
        return false;
      }

      final checkIn = CheckInRecord(
        id: const Uuid().v4(),
        eventId: eventId,
        participantId: participantId,
        participantName: participantName,
        checkedInAt: DateTime.now(),
        isSynced: false,
      );

      await checkInBox.add(checkIn);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error checking in participant: $e');
      return false;
    }
  }

  bool isDuplicateCheckIn(String eventId, String participantId) {
    for (var checkIn in checkInBox.values) {
      if (checkIn.eventId == eventId && checkIn.participantId == participantId) {
        return true;
      }
    }
    return false;
  }

  int getEventCheckInCount(String eventId) {
    int count = 0;
    for (var checkIn in checkInBox.values) {
      if (checkIn.eventId == eventId) {
        count++;
      }
    }
    return count;
  }

  List<CheckInRecord> getEventCheckIns(String eventId) {
    return checkInBox.values
        .where((checkIn) => checkIn.eventId == eventId)
        .toList();
  }

  List<CheckInRecord> searchParticipant(String eventId, String query) {
    final eventCheckIns = getEventCheckIns(eventId);
    return eventCheckIns
        .where((checkIn) =>
            checkIn.participantId.toLowerCase().contains(query.toLowerCase()) ||
            checkIn.participantName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> clearEventCheckIns(String eventId) async {
    try {
      final indices = <int>[];
      for (var i = 0; i < checkInBox.length; i++) {
        if (checkInBox.getAt(i)?.eventId == eventId) {
          indices.add(i);
        }
      }

      for (var i = indices.length - 1; i >= 0; i--) {
        await checkInBox.deleteAt(indices[i]);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing check-ins: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      await checkInBox.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }

  List<CheckInRecord> getUnsyncedCheckIns() {
    return checkInBox.values.where((checkIn) => !checkIn.isSynced).toList();
  }

  Future<void> markAsSynced(String checkInId) async {
    try {
      for (var i = 0; i < checkInBox.length; i++) {
        if (checkInBox.getAt(i)?.id == checkInId) {
          final checkIn = checkInBox.getAt(i);
          if (checkIn != null) {
            checkIn.isSynced = true;
            await checkIn.save();
            notifyListeners();
            break;
          }
        }
      }
    } catch (e) {
      debugPrint('Error marking as synced: $e');
    }
  }
}
