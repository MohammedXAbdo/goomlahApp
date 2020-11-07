part of 'subcategories_bloc.dart';

@immutable
abstract class SubCategoriesState {
  final int currentPage = 1;
  final int categoryId = 1;
}

class SubCategoriesInitial extends SubCategoriesState {}

class SubCategoriesLoading extends SubCategoriesState {
  final int currentPage;
  final int categoryId;

  SubCategoriesLoading({@required this.currentPage, @required this.categoryId});
}

class ContainCategories extends SubCategoriesState {
  final List<Category> categories;
  final int currentPage;
  final int lastPage;
  final int categoryId;

  ContainCategories(
      {@required this.currentPage,
      @required this.lastPage,
      @required this.categoryId,
      @required this.categories})
      : assert(categories != null, 'field mustnot be equall null'),
        assert(lastPage != null, 'field mustnot be equall null'),
        assert(currentPage != null, 'field mustnot be equall null'),
        assert(categoryId != null, 'field mustnot be equall null');
}

class ContainProducts extends SubCategoriesState {
  final List<Product> products;
  final int currentPage;
  final int lastPage;
  final int categoryId;

  ContainProducts(
      {@required this.currentPage,
      @required this.lastPage,
      @required this.categoryId,
      @required this.products})
      : assert(products != null, 'field mustnot be equall null'),
        assert(lastPage != null, 'field mustnot be equall null'),
        assert(currentPage != null, 'field mustnot be equall null'),
        assert(categoryId != null, 'field mustnot be equall null');
}

class CategoriesAndProducts extends SubCategoriesState {
  final List<Product> products;
  final int currentPage;
  final int lastPage;
  final int categoryId;
  final List<Category> categories;

  CategoriesAndProducts(
      {@required this.currentPage,
      @required this.lastPage,
      @required this.categories,
      @required this.categoryId,
      @required this.products})
      : assert(categories != null, 'field mustnot be equall null'),
        assert(products != null, 'field mustnot be equall null'),
        assert(lastPage != null, 'field mustnot be equall null'),
        assert(currentPage != null, 'field mustnot be equall null'),
        assert(categoryId != null, 'field mustnot be equall null');
}

class SubCategoriesFailed extends SubCategoriesState {
  final Failure failure;
  final int currentPage;
  final int categoryId;
  SubCategoriesFailed(
      {@required this.currentPage,
      @required this.categoryId,
      @required this.failure})
      : assert(failure != null, 'field mustnot be equall null');
}
