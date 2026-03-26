import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_sqlite_database/data/db/tables/note_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [NoteTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'note-app');
  }

  @override
  int get schemaVersion => 1;
}
