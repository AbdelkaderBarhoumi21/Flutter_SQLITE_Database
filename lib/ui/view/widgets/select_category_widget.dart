import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view_models/category_view_model.dart';

class SelectCategoryWidget extends ConsumerWidget {
  const SelectCategoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(
      categoryViewModelProvider.select((value) => value.categories),
    );
    final selectedCategoryId = ref.watch(
      categoryViewModelProvider.select((value) => value.selectedCategoryId),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        categories.isEmpty
            ? Text('Categories not available')
            : Wrap(
                spacing: 8.0,
                runSpacing: 8.0,

                children: categories.map((category) {
                  return ChoiceChip(
                    backgroundColor: Colors.grey[200],
                    selectedColor: Colors.blueAccent,
                    checkmarkColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    label: Text(
                      category.name,
                      style: TextStyle(
                        color: selectedCategoryId == category.id
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: selectedCategoryId == category.id,
                    onSelected: (isSelected) {
                      ref
                          .read(categoryViewModelProvider.notifier)
                          .setSelectCategoryId(category.id);
                    },
                  );
                }).toList(),
              ),
      ],
    );
  }
}
