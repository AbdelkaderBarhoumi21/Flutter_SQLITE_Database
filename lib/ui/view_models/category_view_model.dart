import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sqlite_database/data/repository/categories_repository.dart';
import 'package:flutter_sqlite_database/ui/view_models/state/category_state.dart';

final categoryViewModelProvider =
    NotifierProvider<CategoryViewModel, CategoryState>(() {
      return CategoryViewModel();
    });

class CategoryViewModel extends Notifier<CategoryState> {
  StreamSubscription? _categoryStreamSubscription;
  @override
  CategoryState build() {
    ref.onDispose(() {
      _categoryStreamSubscription?.cancel();
    });
    // watchAllCategories() streams the categories in real-time, so we call it in a microtask to avoid blocking the build method.
    Future.microtask(() => watchAllCategories());
    return CategoryState(isLoading: true, categories: []);
  }

  /// Watch all categories in real-time.
  void watchAllCategories() {
    _categoryStreamSubscription = ref
        .read(categoriesRepositoryProvider)
        .watchAllCategories()
        .listen(
          (categories) {
            state = state.copyWith(categories: categories);
          },
          onError: (error, st) {
            state = state.copyWith(
              error:
                  'Failed to watch categories: error: $error, StackTrace: $st',
              isLoading: false,
            );
          },
        );
  }

  /// Fetch all categories once.
  Future<void> getAllCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(categoriesRepositoryProvider);
      final categories = await repo.getAllCategories();
      state = state.copyWith(isLoading: false, categories: categories);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Fetch a single category by its ID.
  Future<void> getCategoryById(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(categoriesRepositoryProvider);
      final category = await repo.getCategoryById(id);
      state = state.copyWith(isLoading: false, selectedCategory: category);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Insert a new category.
  Future<void> insertCategory(String name) async {
    state = state.copyWith(isLoading: true, isCreated: false, error: null);
    try {
      final repo = ref.read(categoriesRepositoryProvider);
      final color = state.selectedColor;
      await repo.insertCategory(name, color);
      state = state.copyWith(isLoading: false, isCreated: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Update an existing category.
  Future<void> updateCategory({
    required int id,
    String? name,
    String? color,
  }) async {
    state = state.copyWith(isLoading: true, isUpdated: false, error: null);
    try {
      final repo = ref.read(categoriesRepositoryProvider);
      final isUpdated = await repo.updateCategory(
        id: id,
        name: name,
        color: color,
      );
      state = state.copyWith(isLoading: false, isUpdated: isUpdated);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isUpdated: false,
        error: e.toString(),
      );
    }
  }

  /// Patch an existing category.
  Future<void> patchCategory({
    required int id,
    String? name,
    String? color,
  }) async {
    state = state.copyWith(isLoading: true, isUpdated: false, error: null);
    try {
      final repo = ref.read(categoriesRepositoryProvider);
      await repo.patchCategory(id: id, name: name, color: color);
      state = state.copyWith(isLoading: false, isUpdated: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isUpdated: false,
        error: e.toString(),
      );
    }
  }

  /// Delete a category by its ID.

  Future<void> deleteCategory(int id) async {
    state = state.copyWith(isLoading: true, error: null, isDeleted: false);
    try {
      final repo = ref.read(categoriesRepositoryProvider);
      await repo.deleteCategory(id);
      state = state.copyWith(isLoading: false, isDeleted: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isDeleted: false,
        error: e.toString(),
      );
    }
  }

  /// Delete all categories.
  /// Returns true if all categories were successfully deleted, false otherwise.
  Future<void> deleteAllCategories() async {
    state = state.copyWith(isLoading: true, error: null, isDeleted: false);
    try {
      final repo = ref.read(categoriesRepositoryProvider);
      await repo.deleteAllCategories();
      state = state.copyWith(isLoading: false, isDeleted: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isDeleted: false,
      );
    }
  }

  void setSelectedColor(String value) {
    state = state.copyWith(selectedColor: value);
  }
}
