part of 'wish_list_bloc.dart';

@immutable
abstract class WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final Product product;

  AddToWishlist({@required this.product});
}

class RemoveFromWishlist extends WishlistEvent {
  final Product product;

  RemoveFromWishlist({@required this.product});
}

class GetWishlistProducts extends WishlistEvent {}

