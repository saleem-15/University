// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LectureAdapter extends TypeAdapter<Lecture> {
  @override
  final int typeId = 1;

  @override
  Lecture read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lecture(
      subject: fields[1] as String,
      day: fields[2] as String,
      startingTime: fields[3] as String,
      endingTime: fields[4] as String,
      place: fields[5] as String,
    )
      ..value = fields[6] as int
      ..dayNum = fields[7] as int;
  }

  @override
  void write(BinaryWriter writer, Lecture obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.startingTime)
      ..writeByte(4)
      ..write(obj.endingTime)
      ..writeByte(5)
      ..write(obj.place)
      ..writeByte(6)
      ..write(obj.value)
      ..writeByte(7)
      ..write(obj.dayNum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LectureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
