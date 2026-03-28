import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view_models/note_view_model.dart';

class NoteListWidget extends ConsumerStatefulWidget {
  const NoteListWidget({super.key});

  @override
  ConsumerState<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends ConsumerState<NoteListWidget> {
 

  @override
  Widget build(BuildContext context) {
  
    final notes = ref.watch(
      noteViewModelProvider.select((value) => value.notes),
    );
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.description ?? ' Description is empty'),
          onTap: () {},
        );
      },
    );
  }
}
