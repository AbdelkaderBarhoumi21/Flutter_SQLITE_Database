import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view/widgets/create_note_view.dart';
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

  @override
  Widget build(BuildContext context) {
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
