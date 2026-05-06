import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/index.dart';

class EventProvider extends ChangeNotifier {
  late Box<Event> eventBox;
  Event? _currentEvent;

  Event? get currentEvent => _currentEvent;

  List<Event> get allEvents {
    if (eventBox.isEmpty) {
      return [];
    }
    return eventBox.values.toList();
  }

  Future<void> initializeBox() async {
    if (!Hive.isBoxOpen('events')) {
      eventBox = await Hive.openBox<Event>('events');
    } else {
      eventBox = Hive.box<Event>('events');
    }
  }

  Future<bool> createEvent({
    required String eventName,
    required DateTime eventDate,
    required int maxCapacity,
  }) async {
    try {
      final event = Event(
        id: const Uuid().v4(),
        eventName: eventName,
        eventDate: eventDate,
        maxCapacity: maxCapacity,
        createdAt: DateTime.now(),
        isActive: true,
      );

      await eventBox.add(event);
      _currentEvent = event;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error creating event: $e');
      return false;
    }
  }

  void setCurrentEvent(Event event) {
    _currentEvent = event;
    notifyListeners();
  }

  Event? getEventById(String eventId) {
    try {
      for (var event in eventBox.values) {
        if (event.id == eventId) {
          return event;
        }
      }
    } catch (e) {
      debugPrint('Error fetching event: $e');
    }
    return null;
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      for (var i = 0; i < eventBox.length; i++) {
        if (eventBox.getAt(i)?.id == eventId) {
          await eventBox.deleteAt(i);
          if (_currentEvent?.id == eventId) {
            _currentEvent = null;
          }
          notifyListeners();
          break;
        }
      }
    } catch (e) {
      debugPrint('Error deleting event: $e');
    }
  }

  Future<bool> updateEvent(Event event, String newName, int newCapacity) async {
    try {
      event.eventName = newName;
      event.maxCapacity = newCapacity;
      await event.save();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating event: $e');
      return false;
    }
  }

  Future<void> clearAllData() async {
    try {
      await eventBox.clear();
      _currentEvent = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }
}
