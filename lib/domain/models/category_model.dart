import 'package:flutter_sqlite_database/data/db/app_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_model.freezed.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  factory CategoryModel({
    required int id,
    required String name,
    required String color,
    required String createdAt,
  }) = _CategoryModel;

  factory CategoryModel.fromEntity(CategoriesTableData category) =>
      CategoryModel(
        id: category.id,
        name: category.name,
        color: category.color,
        createdAt: category.createAt.toString(),
      );
}
