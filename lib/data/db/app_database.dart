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
@DriftDatabase(tables: [NoteTable, CategoriesTable], daos: [NoteDao,CategoryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'note-app');
  }

  @override
  int get schemaVersion => 1;
}
