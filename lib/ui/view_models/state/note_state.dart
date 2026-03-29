import 'package:flutter_sqlite_database/domain/models/note_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_state.freezed.dart';

@freezed
abstract class NoteState with _$NoteState {
  factory NoteState({
    @Default(false) bool isLoading,
    @Default([]) List<NoteModel> notes,
    @Default(false) bool isNoteCreated,
    @Default(false) bool isNoteUpdated,
    NoteModel? note,
    String? error,
  }) = _NoteState;
}
