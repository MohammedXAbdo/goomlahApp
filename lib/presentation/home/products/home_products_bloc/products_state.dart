part of 'products_bloc.dart';

@immutable
abstract class HomeProductsState {
}

class ProductInitial extends HomeProductsState {}

class CategoryProductsLoading extends HomeProductsState {
  final int categoryId;
  CategoryProductsLoading({@required this.categoryId})
      : assert(categoryId != null, 'field shouldnot equal null');
}

class CategoryProductsSucceed extends HomeProductsState {

  final List<Product> products;

  CategoryProductsSucceed({@required this.products})
      : assert(products != null, 'field shouldnot equal null');
}

class CategoryProductsFailed extends HomeProductsState {

  final Failure failure;

  CategoryProductsFailed({@required this.failure})
      : assert(failure != null, 'field mustnot be equall null');
}
