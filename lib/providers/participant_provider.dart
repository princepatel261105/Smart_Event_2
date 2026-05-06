import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/index.dart';

class ParticipantProvider extends ChangeNotifier {
  late Box<Participant> participantBox;

  List<Participant> get allParticipants {
    if (participantBox.isEmpty) {
      return [];
    }
    return participantBox.values.toList();
  }

  Future<void> initializeBox() async {
    if (!Hive.isBoxOpen('participants')) {
      participantBox = await Hive.openBox<Participant>('participants');
    } else {
      participantBox = Hive.box<Participant>('participants');
    }
  }

  Future<bool> addParticipant({
    required String participantId,
    required String name,
    required String eventId,
    String? email,
    String? phone,
  }) async {
    try {
      if (participantExists(eventId, participantId)) {
        return false;
      }

      final participant = Participant(
        id: const Uuid().v4(),
        participantId: participantId,
        name: name,
        email: email,
        phone: phone,
        eventId: eventId,
        createdAt: DateTime.now(),
      );

      await participantBox.add(participant);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding participant: $e');
      return false;
    }
  }

  bool participantExists(String eventId, String participantId) {
    for (var participant in participantBox.values) {
      if (participant.eventId == eventId &&
          participant.participantId == participantId) {
        return true;
      }
    }
    return false;
  }

  Participant? getParticipant(String eventId, String participantId) {
    try {
      for (var participant in participantBox.values) {
        if (participant.eventId == eventId &&
            participant.participantId == participantId) {
          return participant;
        }
      }
    } catch (e) {
      debugPrint('Error fetching participant: $e');
    }
    return null;
  }

  List<Participant> getEventParticipants(String eventId) {
    return participantBox.values
        .where((participant) => participant.eventId == eventId)
        .toList();
  }

  Future<void> clearEventParticipants(String eventId) async {
    try {
      final indices = <int>[];
      for (var i = 0; i < participantBox.length; i++) {
        if (participantBox.getAt(i)?.eventId == eventId) {
          indices.add(i);
        }
      }

      for (var i = indices.length - 1; i >= 0; i--) {
        await participantBox.deleteAt(indices[i]);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing participants: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      await participantBox.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }
}
