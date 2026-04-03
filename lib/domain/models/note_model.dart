import 'package:flutter_sqlite_database/data/db/app_database.dart';
import 'package:flutter_sqlite_database/data/dto/note_with_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'note_model.freezed.dart';

@freezed
abstract class NoteModel with _$NoteModel {
  factory NoteModel({
    required int id,
    required String title,
    required String createdAt,
    String? description,
    @Default(false) bool isCompleted,
    @Default(1) int categoryId,
    @Default('') String categoryName,
    @Default('#2196F3') String categoryColor,
  }) = _NoteModel;

  factory NoteModel.fromEntity(NoteWithCategory data) {
    final note = data.note;
    final category = data.category;

    if (note == null) {
      throw Exception('Note is null');
    }
    return NoteModel(
      id: note.id,
      title: note.title,
      description: note.description,
      isCompleted: note.isCompleted,
      categoryId: note.categoryId ?? 1,
      createdAt: formatDateTimeDifference(note.createdAt),
      categoryName: category?.name ?? '',
      categoryColor: category?.color ?? '#2196F3',
    );
  }

  /// Maps a raw NoteTableData (without category) to NoteModel
  factory NoteModel.fromNoteData(NoteTableData data) {
    return NoteModel(
      id: data.id,
      title: data.title,
      description: data.description,
      isCompleted: data.isCompleted,
      categoryId: data.categoryId ?? 1,
      createdAt: formatDateTimeDifference(data.createdAt),
    );
  }
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
