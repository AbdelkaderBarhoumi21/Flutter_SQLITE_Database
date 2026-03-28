import 'package:flutter_sqlite_database/data/daos/note_daos.dart';
import 'package:flutter_sqlite_database/data/db/app_database.dart';
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
  Future<List<NoteTableData>> getAllNotes() async {
    try {
      return await noteDao.getAllNotes();
    } catch (e, st) {
      throw Exception('Error fetching notes: $e\n$st');
    }
  }

  /// Watch all notes with real-time updates
  Stream<List<NoteTableData>> watchAllNotes() {
    try {
      return noteDao.watchAllNotes();
    } catch (e, st) {
      return Stream.error(Exception('Error watching notes: $e\n$st'));
    }
  }

  /// Insert a new note into the database
  Future<int> insertNote(NoteTableCompanion note) async {
    try {
      return await noteDao.insertNote(note);
    } catch (e, st) {
      throw Exception('Error inserting note: $e\n$st');
    }
  }

  /// Get a specific note by its ID
  Future<NoteTableData?> getNoteById(int id) async {
    try {
      return await noteDao.getNoteById(id);
    } catch (e, st) {
      throw Exception('Error fetching note by ID: $e\n$st');
    }
  }

  /// Update an existing note
  Future<bool> updateNote(NoteTableCompanion note) async {
    try {
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
  Stream<List<NoteTableData>> searchNotes(String query) {
    try {
      return noteDao.searchNotes(query);
    } catch (e, st) {
      return Stream.error(Exception('Error searching notes: $e\n$st'));
    }
  }
}
