import 'package:drift/drift.dart';
import 'package:flutter_sqlite_database/data/db/app_database.dart';
import 'package:flutter_sqlite_database/data/db/tables/category_table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'category_daos.g.dart';

@riverpod
CategoryDao categoryDao(Ref ref) {
  return CategoryDao(ref.read(appDatabaseProvider));
}

@DriftAccessor(tables: [CategoriesTable])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  /// return all categories from the database

  Future<List<CategoriesTableData>> getAllCategories() {
    return select(db.categoriesTable).get();
  }

  /// Watch all categories from the database
  Stream<List<CategoriesTableData>> watchAllCategories() {
    return (select(db.categoriesTable)..orderBy([
          (t) => OrderingTerm(expression: t.createAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  /// insert a category into the database
  Future<int> insertCategory(CategoriesTableCompanion categories) {
    return into(db.categoriesTable).insert(categories);
  }

  /// get category by id from the database
  Future<CategoriesTableData?> getCategoryById(int id) {
    return (select(
      db.categoriesTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<bool> updateCategory(CategoriesTableCompanion category) {
    return update(db.categoriesTable).replace(category);
  }

  /// patch the category by id
  Future<int> patchCategory(CategoriesTableCompanion category) {
    return (update(
      db.categoriesTable,
    )..where((t) => t.id.equals(category.id.value))).write(category);
  }

  /// delete a category by id
  Future<int> deleteCategory(int id) {
    return (delete(db.categoriesTable)..where((t) => t.id.equals(id))).go();
  }

  /// delete all categories from the database
  Future<int> deleteAllCategories() {
    return delete(db.categoriesTable).go();
  }

  Stream<List<CategoriesTableData>> searchCategories(String query) {
    final searchTerm = '%${query.toLowerCase()}%';
    return (select(db.categoriesTable)
          ..where((t) => t.name.lower().like(searchTerm))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }
}
