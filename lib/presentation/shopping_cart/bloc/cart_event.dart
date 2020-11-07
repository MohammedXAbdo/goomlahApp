part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class GetCartProducts extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;

  AddToCart({@required this.product});
}

class RemoveFromCart extends CartEvent {
  final Product product;

  RemoveFromCart({@required this.product});
}

class IncreaseProductCount extends CartEvent {
  final Product product;

  IncreaseProductCount({@required this.product});
}

class DecreaseProductCount extends CartEvent {
  final Product product;
  DecreaseProductCount({@required this.product});
}

class RemoveAllFromCart extends CartEvent {}

class PaymentEvent extends CartEvent {
  final Map<String, int> itemsCount;
  final String additionalAddress ;

  PaymentEvent({@required this.additionalAddress, @required this.itemsCount});
}
