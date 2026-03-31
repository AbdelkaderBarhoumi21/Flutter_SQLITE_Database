import 'package:drift/drift.dart';
import 'package:flutter_sqlite_database/data/daos/category_daos.dart';
import 'package:flutter_sqlite_database/data/db/app_database.dart';
import 'package:flutter_sqlite_database/domain/models/category_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'categories_repository.g.dart';

@riverpod
CategoriesRepository categoriesRepository(Ref ref) {
  return CategoriesRepository(categoryDao: ref.read(categoryDaoProvider));
}

class CategoriesRepository {
  final CategoryDao categoryDao;

  CategoriesRepository({required this.categoryDao});

  /// Get all categories from the database
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final categories = await categoryDao.getAllCategories();
      return categories.map((c) => CategoryModel.fromEntity(c)).toList();
    } catch (e, st) {
      throw Exception('Error fetching categories: $e\n$st');
    }
  }

  /// Watch all categories with real-time updates
  Stream<List<CategoryModel>> watchAllCategories() {
    try {
      final data = categoryDao.watchAllCategories();
      return data
          .map((e) => e.map((e) => CategoryModel.fromEntity(e)).toList())
          .handleError((e, st) {
            throw Exception('Error watching categories after mapping: $e$st');
          });
    } catch (e, st) {
      return Stream.error(Exception('Error watching categories: $e\n$st'));
    }
  }

  /// Insert a new category into the database
  Future<int> insertCategory(String name, String color) async {
    try {
      final category = CategoriesTableCompanion(
        name: Value(name),
        color: Value(color),
      );
      return await categoryDao.insertCategory(category);
    } catch (e, st) {
      throw Exception('Error inserting category: $e\n$st');
    }
  }

  /// Get a specific category by its ID
  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      final data = await categoryDao.getCategoryById(id);
      return data != null ? CategoryModel.fromEntity(data) : null;
    } catch (e, st) {
      throw Exception('Error fetching category by ID: $e\n$st');
    }
  }

  /// Update an existing category
  Future<bool> updateCategory({
    required int id,
    String? name,
    String? color,
  }) async {
    try {
      final category = CategoriesTableCompanion(
        id: Value(id),
        name: Value.absentIfNull(name),
        color: Value.absentIfNull(color),
      );
      return await categoryDao.updateCategory(category);
    } catch (e, st) {
      throw Exception('Error updating category: $e\n$st');
    }
  }

  /// Patch category by id
  Future<int> patchCategory({
    required int id,
    String? name,
    String? color,
  }) async {
    try {
      final category = CategoriesTableCompanion(
        id: Value(id),
        name: Value.absentIfNull(name),
        color: Value.absentIfNull(color),
      );
      return await categoryDao.patchCategory(category);
    } catch (e, st) {
      throw Exception('Error patching category: $e\n$st');
    }
  }

  /// Delete a category by its ID
  Future<int> deleteCategory(int id) async {
    try {
      return await categoryDao.deleteCategory(id);
    } catch (e, st) {
      throw Exception('Error deleting category: $e\n$st');
    }
  }

  /// Delete all categories from the database
  Future<int> deleteAllCategories() async {
    try {
      return await categoryDao.deleteAllCategories();
    } catch (e, st) {
      throw Exception('Error deleting all categories: $e\n$st');
    }
  }

  /// Search categories by query string
  Stream<List<CategoryModel>> searchCategories(String query) {
    try {
      final data = categoryDao.searchCategories(query);
      return data
          .map((e) => e.map((e) => CategoryModel.fromEntity(e)).toList())
          .handleError((e, st) {
            throw Exception('Error searching categories after mapping: $e$st');
          });
    } catch (e, st) {
      return Stream.error(Exception('Error searching categories: $e\n$st'));
    }
  }
}
