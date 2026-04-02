import 'package:flutter/material.dart';

class EditCategoryView extends StatefulWidget {
  const EditCategoryView({super.key});

  @override
  State<EditCategoryView> createState() => _EditCategoryViewState();
}

class _EditCategoryViewState extends State<EditCategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Edit category')));
  }
}
