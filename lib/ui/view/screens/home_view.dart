import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view/screens/category_list_view.dart';
import 'package:flutter_sqlite_database/ui/view/screens/create_note_view.dart';
import 'package:flutter_sqlite_database/ui/view/screens/note_list_view.dart';
import 'package:flutter_sqlite_database/ui/view_models/note_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedIndex = 0;
  static const List<Widget> _screens = [NoteListView(), CategoryListView()];

  static const List<String> _titles = ['Notes list', 'Categories'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: _selectedIndex == 0
            ? [
                MenuAnchor(
                  builder: (context, controller, child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.more_vert),
                    );
                  },
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Clear notes'),
                              content: const Text(
                                'Are you sure you want to clear all notes?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context, true);
                                    await ref
                                        .read(noteViewModelProvider.notifier)
                                        .deleteAllNote();
                                  },
                                  child: const Text('Clear'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Clear notes'),
                    ),
                  ],
                ),
              ]
            : null,
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateNoteView()),
              ),
              label: Text('Add note'),
              icon: const Icon(Icons.save_outlined),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
        ],
      ),
    );
  }
}
