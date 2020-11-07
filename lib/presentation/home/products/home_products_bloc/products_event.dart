part of 'products_bloc.dart';

@immutable
abstract class HomeProductsEvent {}

class FetchingCategoryProducts extends HomeProductsEvent {
  final int categoryId;
  FetchingCategoryProducts({@required this.categoryId})
      : assert(categoryId != null, 'field shouldn\'t equll null ');
}
