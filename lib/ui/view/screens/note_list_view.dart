import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view/screens/create_note_view.dart';
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
      ref.read(noteViewModelProvider.notifier).getAllNotes();
    });
    super.initState();
  }

  void _stateListener() {
    ref.listen(noteViewModelProvider.select((value) => value.isNoteCreated), (
      previous,
      next,
    ) {
      // previous => old value and next the new value
      // isNoteCreated old value =false and new value = true
      if (next) {
        // refresh note list
        ref.read(noteViewModelProvider.notifier).getAllNotes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _stateListener();
    return Scaffold(
      appBar: AppBar(title: const Text('Notes list')),
      body: NoteListWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateNoteView()),
        ),
        label: Text('Add note'),
        icon: const Icon(Icons.save_outlined),
      ),
    );
  }
}
