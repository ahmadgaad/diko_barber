import 'package:ronaq_barber/core/shared/domain/entities/category.dart';

sealed class CategoriesState {
  const CategoriesState();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded(this.categories);
  final List<Category> categories;
}

class CategoriesError extends CategoriesState {
  const CategoriesError();
}
