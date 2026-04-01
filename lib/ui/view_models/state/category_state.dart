import 'package:flutter_sqlite_database/domain/models/category_model.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_state.freezed.dart';

@freezed
abstract class CategoryState with _$CategoryState{
  factory CategoryState({
    @Default(false) bool isLoading,
    @Default(false) bool isCreated,
    @Default(false) bool isUpdated,
    @Default(false) bool isDeleted,
    @Default([]) List<CategoryModel> categories,
    CategoryModel? category,
    String? error,
  }) = _CategoryState;
}
