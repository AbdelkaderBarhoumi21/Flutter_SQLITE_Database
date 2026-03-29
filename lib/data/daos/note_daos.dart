import 'package:drift/drift.dart';
import 'package:flutter_sqlite_database/data/db/app_database.dart';
import 'package:flutter_sqlite_database/data/db/tables/note_table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'note_daos.g.dart';

@riverpod
NoteDao noteDao(Ref ref) {
  final db = ref.read(appDatabaseProvider);
  return NoteDao(db);
}

@DriftAccessor(tables: [NoteTable])
class NoteDao extends DatabaseAccessor<AppDatabase> with _$NoteDaoMixin {
  NoteDao(super.db);

  /// Return data class because our AppDatabase.g.dart  => generated data class that represents a row from your NoteTable.
  // Return all values from the database
  Future<List<NoteTableData>> getAllNotes() {
    return select(db.noteTable).get();
  }

  /// watch all notes from the database
  Stream<List<NoteTableData>> watchAllNotes() {
    return (select(db.noteTable)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  /// insert a record into the database
  Future<int> insertNote(NoteTableCompanion note) {
    return into(db.noteTable).insert(note);
  }

  /// get note by id from the database
  Future<NoteTableData?> getNoteById(int id) {
    return (select(
      db.noteTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  ///update a note by id
  Future<bool> updateNote(NoteTableCompanion note) {
    return update(db.noteTable).replace(note);
  }

  /// patch the note by id
  /// write() => Writes all non-null fields from [entity] into the columns of all rows that match the [where] clause.
  /// The fields that are null on the [entity] object will not be changed by this operation, they will be ignored.
  Future<int> patchNote(NoteTableCompanion note) {
    return (update(
      db.noteTable,
    )..where((t) => t.id.equals(note.id.value))).write(note);
  }

  /// delete a note by id
  /// go()=> Deletes all rows matched by the set [where] clause (id)
  /// Returns the amount of rows that were deleted by this statement
  Future<int> deleteNote(int id) {
    return (delete(db.noteTable)..where((t) => t.id.equals(id))).go();
  }

  /// delete all notes
  Future<int> deleteAllNotes() {
    return delete(db.noteTable).go();
  }

  /// search notes by title or description
  Stream<List<NoteTableData>> searchNotes(String query) {
    final searchTerm = '%${query.toLowerCase()}%';
    return (select(db.noteTable)
          ..where(
            (t) => t.title.like(searchTerm) | t.description.like(searchTerm),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }
}
