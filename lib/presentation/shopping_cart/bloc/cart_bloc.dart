import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({@required this.storage, @required this.databaseImpl})
      : super(CartInitial());
  final DatabaseRepository databaseImpl;
  final LocalDatabaseRepository storage;
  List<Product> _products = [];
  List<Product> get products => _products;

  Map<String, int> _itemsCount = {};

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is GetCartProducts) {
      yield CartLoading();
      yield CartSucceed(products: products, itemsCount: _itemsCount);
    } else if (event is AddToCart) {
      yield CartLoading();
      _products.add(event.product);
      _itemsCount[event.product.id.toString()] = 1;
      add(GetCartProducts());
    }
    if (event is RemoveFromCart) {
      yield CartLoading();
      _products.remove(event.product);
      _itemsCount.remove(event.product.id.toString());
      add(GetCartProducts());
    } else if (event is IncreaseProductCount) {
      yield CartLoading();
      _itemsCount[event.product.id.toString()] += 1;
      add(GetCartProducts());
    } else if (event is DecreaseProductCount) {
      yield CartLoading();
      if (_itemsCount[event.product.id.toString()] == 1) {
        add(RemoveFromCart(product: event.product));
      } else {
        _itemsCount[event.product.id.toString()] -= 1;
        add(GetCartProducts());
      }
    } else if (event is RemoveAllFromCart) {
      _products.clear();
      _itemsCount.clear();
      add(GetCartProducts());
    } else if (event is PaymentEvent) {
      yield* handlePaymentEvent(event);
    }
  }

  Stream<CartState> handlePaymentEvent(PaymentEvent event) async* {
    yield PaymentLoading();
    try {
      if (!await Functions.getNetworkStatus()) {
        throw NetworkFailure();
      }
      final token = await storage.read(key: storage.tokenKey);
      if (token == null) {
        throw UnimplementedFailure();
      }
      await databaseImpl.paymentRequest(
          itemsCount: event.itemsCount,
          token: token,
          additonalAddress: event.additionalAddress,
          timeId: DateTime.now().millisecondsSinceEpoch);
      add(RemoveAllFromCart());
      yield PaymentSucceed();
    } on Failure catch (failure) {
      yield PaymentFailed(failure: failure);
    }
  }
}
