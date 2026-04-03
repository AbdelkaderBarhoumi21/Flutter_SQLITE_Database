import 'package:flutter_sqlite_database/data/db/app_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'note_model.freezed.dart';

@freezed
abstract class NoteModel with _$NoteModel {
  factory NoteModel({
    required int id,
    required String title,
    @Default(1) int categoryId,
    String? description,
    @Default(false) bool isCompleted,
    required String createdAt,
  }) = _NoteModel;

  factory NoteModel.fromEntity(NoteTableData note) => NoteModel(
    id: note.id,
    categoryId: note.categoryId ?? 1,
    title: note.title,
    description: note.description,
    isCompleted: note.isCompleted,
    createdAt: formatDateTimeDifference(note.createdAt),
  );
}

String formatDateTimeDifference(DateTime date) {
  final now = DateTime.now();
  final dif = now.difference(date);

  if (dif.inDays > 0) {
    return '${dif.inDays} days ago';
  } else if (dif.inHours > 0) {
    return '${dif.inHours} hours ago';
  } else if (dif.inMinutes > 0) {
    return '${dif.inMinutes} minutes ago';
  } else {
    return 'Just now';
  }
}
