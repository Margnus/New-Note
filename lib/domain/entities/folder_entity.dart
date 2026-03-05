import 'package:equatable/equatable.dart';

class FolderEntity extends Equatable {
  final String id;
  final String name;
  final String? parentId;
  final DateTime createdAt;

  const FolderEntity({
    required this.id,
    required this.name,
    this.parentId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, parentId, createdAt];

  FolderEntity copyWith({
    String? id,
    String? name,
    String? parentId,
    DateTime? createdAt,
  }) {
    return FolderEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
