import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view/screens/category_list_view.dart';
import 'package:flutter_sqlite_database/ui/view/screens/create_category_view.dart';
import 'package:flutter_sqlite_database/ui/view/screens/create_note_view.dart';
import 'package:flutter_sqlite_database/ui/view/screens/note_list_view.dart';
import 'package:flutter_sqlite_database/ui/view_models/category_view_model.dart';
import 'package:flutter_sqlite_database/ui/view_models/note_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedIndex = 0;
  static const List<Widget> _screens = [NoteListView(), CategoryListView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Notes list' : 'Categories list'),
        actions: [
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
                        title: Text(
                          _selectedIndex == 0
                              ? 'Clear notes'
                              : 'Clear categories',
                        ),
                        content: Text(
                          _selectedIndex == 0
                              ? 'Are you sure you want to clear all notes?'
                              : 'Are you sure you want to clear all categories?',
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
                            onPressed: () async {
                              Navigator.pop(context, true);
                              if (_selectedIndex == 0) {
                                await ref
                                    .read(noteViewModelProvider.notifier)
                                    .deleteAllNote();
                              } else {
                                await ref
                                    .read(categoryViewModelProvider.notifier)
                                    .deleteAllCategories();
                              }
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  _selectedIndex == 0 ? 'Clear notes' : 'Clear categories',
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => _selectedIndex == 0
                ? const CreateNoteView()
                : const CreateCategoryView(),
          ),
        ),
        label: Text(_selectedIndex == 0 ? 'Add note' : 'Add category'),
        icon: const Icon(Icons.save_outlined),
      ),
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
