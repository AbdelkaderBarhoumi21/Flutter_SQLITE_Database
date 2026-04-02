import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/ui/view/widgets/category_list_widget.dart';

class CategoryListView extends ConsumerStatefulWidget {
  const CategoryListView({super.key});

  @override
  ConsumerState<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends ConsumerState<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    return CategoryListWidget();
  }
}
