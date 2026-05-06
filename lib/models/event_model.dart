import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String eventName;

  @HiveField(2)
  late DateTime eventDate;

  @HiveField(3)
  late int maxCapacity;

  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  late bool isActive;

  Event({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.maxCapacity,
    required this.createdAt,
    this.isActive = true,
  });

  Event.empty()
      : id = '',
        eventName = '',
        eventDate = DateTime.now(),
        maxCapacity = 0,
        createdAt = DateTime.now(),
        isActive = false;
}
