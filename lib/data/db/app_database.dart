import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_sqlite_database/data/daos/category_daos.dart';
import 'package:flutter_sqlite_database/data/daos/note_daos.dart';
import 'package:flutter_sqlite_database/data/db/tables/category_table.dart';
import 'package:flutter_sqlite_database/data/db/tables/note_table.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

/// keep our AppDatabase open as long as our app is running don't auto dispose
///
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    db.close();
  });
  return db;
}

/// This the main DB class
/// daos  mean => NoteDao get noteDao => NoteDao(this);
/// Include this DAO in my database and give me a noteDao property to access it
@DriftDatabase(
  tables: [NoteTable, CategoriesTable],
  daos: [NoteDao, CategoryDao],
)
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 3;
  AppDatabase() : super(_openConnection());

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'note-app');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // Executes when the database is opened for the first time.
      // Creates all tables, triggers, views, indexes and everything else defined in the database, if they don't exist.
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        return m.createTable(categoriesTable);
      }

      if (from < 3) {
        return m.addColumn(noteTable, noteTable.categoryId);
      }
    },
    beforeOpen: (details) async {
      // This will be executed when the database is opened, and before the [onCreate] or [onUpgrade] callbacks are called.
      // and before any other queries will be sent.
      // it enables SQLite foreign key enforcement with PRAGMA foreign_keys=ON. By default SQLite ignores foreign key constraints,
      // so you have to enable it manually for each connection. This ensures that your database maintains referential integrity by enforcing foreign key constraints.
      await customStatement('PRAGMA foreign_keys=ON');
    },
  );
}
