// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckInRecordAdapter extends TypeAdapter<CheckInRecord> {
  @override
  final int typeId = 2;

  @override
  CheckInRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckInRecord(
      id: fields[0] as String,
      eventId: fields[1] as String,
      participantId: fields[2] as String,
      participantName: fields[3] as String,
      checkedInAt: fields[4] as DateTime,
      isSynced: fields[5] as bool,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CheckInRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventId)
      ..writeByte(2)
      ..write(obj.participantId)
      ..writeByte(3)
      ..write(obj.participantName)
      ..writeByte(4)
      ..write(obj.checkedInAt)
      ..writeByte(5)
      ..write(obj.isSynced)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckInRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
