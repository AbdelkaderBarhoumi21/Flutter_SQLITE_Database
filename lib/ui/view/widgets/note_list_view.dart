import 'package:flutter/material.dart';
import 'package:flutter_sqlite_database/ui/view/widgets/create_note_view.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes list')),
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
