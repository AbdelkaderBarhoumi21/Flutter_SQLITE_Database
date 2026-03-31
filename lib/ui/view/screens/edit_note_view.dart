import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view_models/note_view_model.dart';

class EditNoteView extends ConsumerStatefulWidget {
  const EditNoteView({required this.noteId, super.key});
  final int noteId;

  @override
  ConsumerState<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends ConsumerState<EditNoteView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // fetch the note details using the noteId
      ref.read(noteViewModelProvider.notifier).getNoteById(widget.noteId);
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onUpdateNote() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      ref
          .read(noteViewModelProvider.notifier)
          .patchNote(id: widget.noteId, title: title, description: description);
    }
  }

  void _stateListener() {
    ref.listen(noteViewModelProvider.select((value) => value.isNoteUpdated), (
      previous,
      next,
    ) {
      // previous => old value and next the new value
      // isNoteUpdated old value =false and new value = true
      if (next) {
        // refresh note list
        ref.read(noteViewModelProvider.notifier).getNoteById(widget.noteId);
       // ref.read(noteViewModelProvider.notifier).getAllNotes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _stateListener();
    final note = ref.watch(noteViewModelProvider.select((state) => state.note));
    final title = note?.title ?? '';
    final description = note?.description ?? '';
    _titleController.text = title;
    _descriptionController.text = description;
    final isCompleted = note?.isCompleted ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit note')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onUpdateNote,
        label: const Text('Update note'),
        icon: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter note title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter note description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Checkbox.adaptive(
                      value: isCompleted,
                      onChanged: (value) {
                        ref
                            .read(noteViewModelProvider.notifier)
                            .patchNote(id: widget.noteId, isCompleted: value);
                      },
                    ),
                    const Text('Mark as completed'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
