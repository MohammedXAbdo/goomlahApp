part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class FetchProductData extends ProductEvent {
  final int id;

  FetchProductData({@required this.id});
}
