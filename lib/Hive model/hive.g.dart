// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyPostureStatAdapter extends TypeAdapter<DailyPostureStat> {
  @override
  final int typeId = 0;

  @override
  DailyPostureStat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyPostureStat(
      date: fields[0] as DateTime,
      slouchTime: fields[1] as Duration,
      slouchPercentage: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailyPostureStat obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.slouchTime)
      ..writeByte(2)
      ..write(obj.slouchPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPostureStatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
