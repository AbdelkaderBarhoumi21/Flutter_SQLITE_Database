import 'package:flutter_sqlite_database/data/db/app_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_with_category.freezed.dart';

// SELECT notes.id, notes.title, notes.description, categories.name AS categoryName FROM notes
// INNER JOIN categories ON notes.category_id = categories.id
@freezed
abstract class NoteWithCategory with _$NoteWithCategory {
  const factory NoteWithCategory({
    final NoteTableData? note,
    final CategoriesTableData? category,
  }) = _NoteWithCategory;
}


