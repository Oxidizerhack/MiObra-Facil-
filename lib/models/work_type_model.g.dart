// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkTypeAdapter extends TypeAdapter<WorkType> {
  @override
  final int typeId = 0;

  @override
  WorkType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkType(
      id: fields[0] as String,
      description: fields[1] as String,
      unit: fields[2] as String,
      prices: (fields[3] as Map).cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.unit)
      ..writeByte(3)
      ..write(obj.prices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
