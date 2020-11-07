part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSucceed extends CartState {
  final List<Product> products;
  final Map<String, int> itemsCount;
  CartSucceed({@required this.itemsCount, @required this.products});
}

class PaymentLoading extends CartState {}

class PaymentSucceed extends CartState {}

class PaymentFailed extends CartState {
  final Failure failure;

  PaymentFailed({@required this.failure});
}
