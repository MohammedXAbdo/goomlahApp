part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class ProductsSearchLoading extends SearchState {}

class ProductsSearchSucceed extends SearchState {
  final List<Product> products;

  ProductsSearchSucceed({@required this.products})
      : assert(products != null, 'field shouldnot be null');
}

class ProductsSearchFailed extends SearchState {
  final Failure failure;
  ProductsSearchFailed({@required this.failure})
      : assert(failure != null, 'field mustnot be equall null');
}

class ProductsSearchEmpty extends SearchState {}

class AllCategoriesLoading extends SearchState {}

class AllCategoriesSucceed extends SearchState {
  final List<Category> categories;
  AllCategoriesSucceed({@required this.categories})
      : assert(categories != null, 'field mustnot be equall null');
}
