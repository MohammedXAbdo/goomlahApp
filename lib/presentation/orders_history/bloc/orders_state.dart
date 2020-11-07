part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersSucceed extends OrdersState {
  final List<Order> orders;

  OrdersSucceed({@required this.orders});
}

class OrdersFailed extends OrdersState {
  final Failure failure;

  OrdersFailed({@required this.failure});
}
