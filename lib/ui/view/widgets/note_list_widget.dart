import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view/screens/edit_note_view.dart';
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
        return Dismissible(
          key: Key(note.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          dismissThresholds: const {DismissDirection.endToStart: 0.5},
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete note'),
                  content: const Text(
                    'Are you sure you want to delete this note?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            ref.read(noteViewModelProvider.notifier).deleteNote(note.id);
          },

          child: ListTile(
            title: Row(
              children: [
                Text(note.title),
                const Spacer(),
                Text(note.categoryId.toString()),
              ],
            ),
            subtitle: Text(note.description ?? ' Description is empty'),
            leading: Checkbox(value: note.isCompleted, onChanged: (value) {}),
            trailing: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditNoteView(noteId: note.id),
                  ),
                );
              },
              icon: Icon(Icons.edit),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
