import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/data/repository/note_repository.dart';
import 'package:flutter_sqlite_database/ui/view_models/state/note_state.dart';

final noteViewModelProvider = NotifierProvider<NoteViewModel, NoteState>(() {
  return NoteViewModel();
});

class NoteViewModel extends Notifier<NoteState> {
  StreamSubscription? _noteStreamSubscription;

  @override
  NoteState build() {
    ref.onDispose(() {
      _noteStreamSubscription?.cancel();
    });
    // watchAllNotes();
    return NoteState(notes: [], isLoading: true);
  }

  Future<void> watchAllNotes() async {
    _noteStreamSubscription = ref
        .read(noteRepositoryProvider)
        .watchAllNotes()
        .listen(
          (notes) {
            state = state.copyWith(notes: notes);
          },
          onError: (error, st) {
            state = state.copyWith(
              error: 'Failed to watch notes: error: $error, StackTrace: $st',
            );
          },
        );
  }

  Future<void> getAllNotes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(noteRepositoryProvider);
      final notes = await repo.getAllNotes();
      state = state.copyWith(isLoading: false, notes: notes);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getNoteById(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(noteRepositoryProvider);
      final note = await repo.getNoteById(id);
      state = state.copyWith(isLoading: false, note: note);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> insertNote(String title, String description) async {
    state = state.copyWith(isLoading: true, isNoteCreated: false, error: null);
    try {
      final repo = ref.read(noteRepositoryProvider);

      await repo.insertNote(title, description);
      state = state.copyWith(isLoading: false, isNoteCreated: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateNote({
    required int id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    state = state.copyWith(isLoading: true, isNoteUpdated: false, error: null);
    try {
      final repo = ref.read(noteRepositoryProvider);

      final isNoteUpdated = await repo.updateNote(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
      );
      state = state.copyWith(isLoading: false, isNoteUpdated: isNoteUpdated);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isNoteUpdated: false,
        error: e.toString(),
      );
    }
  }

  Future<void> patchNote({
    required int id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    state = state.copyWith(isLoading: true, isNoteUpdated: false, error: null);
    try {
      final repo = ref.read(noteRepositoryProvider);

      await repo.patchNote(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
      );
      state = state.copyWith(isLoading: false, isNoteUpdated: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isNoteUpdated: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteNote(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(noteRepositoryProvider);
      await repo.deleteNote(id);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteAllNote() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(noteRepositoryProvider);
      await repo.deleteAllNotes();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
