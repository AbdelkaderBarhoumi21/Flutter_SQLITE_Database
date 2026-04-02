import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view_models/category_view_model.dart';

class CreateCategoryView extends ConsumerStatefulWidget {
  const CreateCategoryView({super.key});

  @override
  ConsumerState<CreateCategoryView> createState() => _CreateCategoryViewState();
}

class _CreateCategoryViewState extends ConsumerState<CreateCategoryView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final List<String> _colors = [
    '#FF0000', // Red
    '#00FF00', // Green
    '#0000FF', // Blue
    '#FFFF00', // Yellow
    '#FF00FF', // Purple
    '#FFA500', // Orange
    '#FFC0CB', // Pink
    '#A52A2A', // Brown
    '#808080', // Gray
  ];

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.black; // Default color if parsing fails
    }
  }

  void _onSaveCategory() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      final name = _nameController.text;
      ref.read(categoryViewModelProvider.notifier).insertCategory(name);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Category')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSaveCategory,
        label: const Text('Add category'),
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
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter category name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 18),
                Consumer(
                  builder: (context, ref, child) {
                    final selectedColor = ref.watch(
                      categoryViewModelProvider.select(
                        (value) => value.selectedColor,
                      ),
                    );
                    return SizedBox(
                      height: 60,
                      child: ListView.builder(
                        itemCount: _colors.length,
                        itemBuilder: (context, index) {
                          final color = _colors[index];
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(categoryViewModelProvider.notifier)
                                  .setSelectedColor(color);
                            },
                            child: CircleAvatar(
                              backgroundColor: _parseColor(color),
                              radius: 24,
                              child: selectedColor == color
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
