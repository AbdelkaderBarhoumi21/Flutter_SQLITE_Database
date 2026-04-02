import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view/screens/create_category_view.dart';
import 'package:flutter_sqlite_database/ui/view/widgets/category_list_widget.dart';
import 'package:flutter_sqlite_database/ui/view_models/category_view_model.dart';

class CategoryListView extends ConsumerStatefulWidget {
  const CategoryListView({super.key});

  @override
  ConsumerState<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends ConsumerState<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories list'),
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
                        title: const Text('Clear categories'),
                        content: const Text(
                          'Are you sure you want to clear all categories?',
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
                              await ref
                                  .read(categoryViewModelProvider.notifier)
                                  .deleteAllCategories();
                    
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
        ],
      ),

      body: CategoryListWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateCategoryView()),
        ),
        label: Text('Add category'),
        icon: const Icon(Icons.save_outlined),
      ),
    );
  }
}
