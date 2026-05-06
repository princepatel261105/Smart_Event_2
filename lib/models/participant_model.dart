import 'package:hive/hive.dart';

part 'participant_model.g.dart';

@HiveType(typeId: 1)
class Participant extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String participantId;

  @HiveField(2)
  late String name;

  @HiveField(3)
  late String? email;

  @HiveField(4)
  late String? phone;

  @HiveField(5)
  late String eventId;

  @HiveField(6)
  late DateTime createdAt;

  Participant({
    required this.id,
    required this.participantId,
    required this.name,
    this.email,
    this.phone,
    required this.eventId,
    required this.createdAt,
  });

  Participant.empty()
      : id = '',
        participantId = '',
        name = '',
        email = '',
        phone = '',
        eventId = '',
        createdAt = DateTime.now();
}
