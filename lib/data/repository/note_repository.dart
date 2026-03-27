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
    return await noteDao.getAllNotes();
  }

  /// Watch all notes with real-time updates
  Stream<List<NoteTableData>> watchAllNotes() {
    return noteDao.watchAllNotes();
  }

  /// Insert a new note into the database
  Future<int> insertNote(NoteTableCompanion note) async {
    return await noteDao.insertNote(note);
  }

  /// Get a specific note by its ID
  Future<NoteTableData?> getNoteById(int id) async {
    return await noteDao.getNoteById(id);
  }

  /// Update an existing note
  Future<bool> updateNote(NoteTableCompanion note) async {
    return noteDao.updateNote(note);
  }

  /// Delete a note by its ID
  Future<int> deleteNote(int id) async {
    return noteDao.deleteNote(id);
  }

  /// Delete all notes from the database
  Future<int> deleteAllNotes() async {
    return noteDao.deleteAllNotes();
  }

  /// Search notes by query string
  Stream<List<NoteTableData>> searchNotes(String query) {
    return noteDao.searchNotes(query);
  }
}
