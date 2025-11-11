// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 2;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      id: fields[0] as String,
      projectName: fields[1] as String,
      clientName: fields[2] as String,
      region: fields[3] as String,
      jobs: (fields[4] as List).cast<Job>(),
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projectName)
      ..writeByte(2)
      ..write(obj.clientName)
      ..writeByte(3)
      ..write(obj.region)
      ..writeByte(4)
      ..write(obj.jobs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
