import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String? folderId;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final DateTime? deletedAt;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    this.folderId,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        folderId,
        isPinned,
        createdAt,
        updatedAt,
        isDeleted,
        deletedAt,
      ];

  NoteEntity copyWith({
    String? id,
    String? title,
    String? content,
    String? folderId,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      folderId: folderId ?? this.folderId,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
