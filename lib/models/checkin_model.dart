import 'package:hive/hive.dart';

part 'checkin_model.g.dart';

@HiveType(typeId: 2)
class CheckInRecord extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String eventId;

  @HiveField(2)
  late String participantId;

  @HiveField(3)
  late String participantName;

  @HiveField(4)
  late DateTime checkedInAt;

  @HiveField(5)
  late bool isSynced;

  @HiveField(6)
  late String? notes;

  CheckInRecord({
    required this.id,
    required this.eventId,
    required this.participantId,
    required this.participantName,
    required this.checkedInAt,
    this.isSynced = false,
    this.notes,
  });

  CheckInRecord.empty()
      : id = '',
        eventId = '',
        participantId = '',
        participantName = '',
        checkedInAt = DateTime.now(),
        isSynced = false;
}
