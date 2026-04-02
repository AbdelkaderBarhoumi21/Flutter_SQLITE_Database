import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view/widgets/note_list_widget.dart';
import 'package:flutter_sqlite_database/ui/view_models/note_view_model.dart';

class NoteListView extends ConsumerStatefulWidget {
  const NoteListView({super.key});

  @override
  ConsumerState<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends ConsumerState<NoteListView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(noteViewModelProvider.notifier).watchAllNotes();
    });
    super.initState();
  }

  void _stateListener() {
    ref.listen(noteViewModelProvider.select((value) => value.isNoteCreated), (
      previous,
      next,
    ) {
      if (next) {
        // refresh note list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _stateListener();
    return NoteListWidget();
  }
}
