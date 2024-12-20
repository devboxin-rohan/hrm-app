// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'punch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PunchModelAdapter extends TypeAdapter<PunchModel> {
  @override
  final int typeId = 1;

  @override
  PunchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PunchModel(
      id: fields[0] as String?,
      imagePath: fields[1] as String?,
      latitude: fields[2] as double?,
      longitude: fields[3] as double?,
      dateTime: fields[4] as String?,
      isSync: fields[5] as bool?,
      isLoading: fields[6] as bool,
      error: fields[7] as String?,
      user_id: fields[8] as int?,
      isPunchin: fields[9] as bool?,
      app_type: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PunchModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.isSync)
      ..writeByte(6)
      ..write(obj.isLoading)
      ..writeByte(7)
      ..write(obj.error)
      ..writeByte(8)
      ..write(obj.user_id)
      ..writeByte(9)
      ..write(obj.isPunchin)
      ..writeByte(10)
      ..write(obj.app_type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PunchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
