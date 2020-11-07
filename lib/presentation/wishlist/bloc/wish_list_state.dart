part of 'wish_list_bloc.dart';

@immutable
abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistSucceed extends WishlistState {
  final List<Product> products;
  WishlistSucceed({@required this.products});
}


class WishlistFailed extends WishlistState {
  final Failure failure;
  WishlistFailed({@required this.failure});
}
