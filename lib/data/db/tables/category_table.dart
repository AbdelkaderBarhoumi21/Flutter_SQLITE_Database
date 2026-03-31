import 'package:drift/drift.dart';

class CategoriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 3, max: 50)();
  TextColumn get color => text().withLength(min: 7, max: 10)();
  DateTimeColumn get createAt => dateTime().withDefault(currentDateAndTime)();
}
