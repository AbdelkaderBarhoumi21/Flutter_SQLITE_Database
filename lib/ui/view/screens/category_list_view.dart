import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryListView extends ConsumerStatefulWidget {
  const CategoryListView({super.key});

  @override
  ConsumerState<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends ConsumerState<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Categories list')));
  }
}
