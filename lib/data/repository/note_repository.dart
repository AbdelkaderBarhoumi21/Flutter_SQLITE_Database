import 'package:drift/drift.dart';
import 'package:flutter_sqlite_database/data/daos/note_daos.dart';
import 'package:flutter_sqlite_database/data/db/app_database.dart';
import 'package:flutter_sqlite_database/domain/models/note_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'note_repository.g.dart';

@riverpod
NoteRepository noteRepository(Ref ref) {
  final noteDao = ref.read(noteDaoProvider);
  return NoteRepository(noteDao: noteDao);
}

class NoteRepository {
  NoteRepository({required this.noteDao});
  NoteDao noteDao;

  /// Get all notes from the database
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final data = await noteDao.getAllNotes();
      return data.map((e) => NoteModel.fromEntity(e)).toList();
    } catch (e, st) {
      throw Exception('Error fetching notes: $e\n$st');
    }
  }

  /// Watch all notes with real-time updates
  Stream<List<NoteModel>> watchAllNotes() {
    try {
      final data = noteDao.watchAllNotes();
      //First .map() - Stream mapping
      //Second .map() - List mapping

      return data
          .map((e) => e.map((e) => NoteModel.fromEntity(e)).toList())
          .handleError((e, st) {
            throw Exception('Error watching notes after mapping :$e$st');
          });
    } catch (e, st) {
      return Stream.error(Exception('Error watching notes: $e\n$st'));
    }
  }

  /// Insert a new note into the database
  Future<int> insertNote(String title, String description) async {
    try {
      final note = NoteTableCompanion(
        title: Value(title),
        description: Value(description),
      );
      final data = await noteDao.insertNote(note);
      return data;
    } catch (e, st) {
      throw Exception('Error inserting note: $e\n$st');
    }
  }

  /// Get a specific note by its ID
  Future<NoteModel?> getNoteById(int id) async {
    try {
      final data = await noteDao.getNoteById(id);
      return data != null ? NoteModel.fromEntity(data) : null;
    } catch (e, st) {
      throw Exception('Error fetching note by ID: $e\n$st');
    }
  }

  /// Update an existing note
  Future<bool> updateNote({
    required int id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    try {
      final note = NoteTableCompanion(
        id: Value(id),
        title: Value.absentIfNull(title),
        description: Value.absentIfNull(description),
        isCompleted: Value.absentIfNull(isCompleted ?? false),
      );
      return await noteDao.updateNote(note);
    } catch (e, st) {
      throw Exception('Error updating note: $e\n$st');
    }
  }

  /// Delete a note by its ID
  Future<int> deleteNote(int id) async {
    try {
      return await noteDao.deleteNote(id);
    } catch (e, st) {
      throw Exception('Error deleting note: $e\n$st');
    }
  }

  /// Delete all notes from the database
  Future<int> deleteAllNotes() async {
    try {
      return await noteDao.deleteAllNotes();
    } catch (e, st) {
      throw Exception('Error deleting all notes: $e\n$st');
    }
  }

  /// Search notes by query string
  Stream<List<NoteModel>> searchNotes(String query) {
    // try-catch handles errors when creating the stream,
    // .handleError() handles errors during stream emission and mapping.
    try {
      final data = noteDao.searchNotes(query);
      return data
          .map((e) => e.map((e) => NoteModel.fromEntity(e)).toList())
          .handleError((e, st) {
            throw Exception('Error searching notes after mapping :$e$st');
          });
    } catch (e, st) {
      return Stream.error(Exception('Error searching notes: $e\n$st'));
    }
  }
}
