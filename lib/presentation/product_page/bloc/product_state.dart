part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSucceed extends ProductState {
  final Product product;

  ProductSucceed({@required this.product});
}

class ProductFailed extends ProductState {
  final Failure failure;

  ProductFailed({@required this.failure});
}
