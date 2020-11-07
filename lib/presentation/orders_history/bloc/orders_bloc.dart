import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/model/order.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({@required this.databaseImpl, @required this.storage})
      : super(OrdersInitial());
  final LocalDatabaseRepository storage;
  final DatabaseRepository databaseImpl;
  bool previousIsCart = false;
  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is FetchOrdersHistory) {
      yield OrdersLoading();
      try {
        if (!await Functions.getNetworkStatus()) {
          throw NetworkFailure();
        }
        final token = await storage.read(key: storage.tokenKey);
        if (token == null) throw UnimplementedFailure();
        final List<Order> orders = await databaseImpl.fetchOrders(token: token);
        yield OrdersSucceed(orders: orders);
      } on Failure catch (failure) {
        yield OrdersFailed(failure: failure);
      }
    }
  }
}
