import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'wish_list_event.dart';
part 'wish_list_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({@required this.storage, @required this.databaseImpl})
      : super(WishlistInitial());
  final LocalDatabaseRepository storage;
  final DatabaseRepository databaseImpl;

  List<Product> products;
  @override
  Stream<WishlistState> mapEventToState(
    WishlistEvent event,
  ) async* {
    if (event is GetWishlistProducts) {
      yield WishlistLoading();
      try {
        if (!await Functions.getNetworkStatus()) {
          throw NetworkFailure();
        }
        if (products == null) {
          final productsIds = await getProductsId();
          products = [];
          for (var id in productsIds) {
            final product = await databaseImpl.fetchProduct(id: int.parse(id));
            if (product == null) {
              storage.delete(
                tableName: storage.productsWishlistTable,
                key: product.id.toString(),
              );
            } else {
              products.add(product);
            }
          }
        }
        yield WishlistSucceed(products: products);
      } on Failure catch (failure) {
        if (failure is NetworkFailure) {
          final productsIds = await getProductsId();
          List<Product> products = [];
          for (var id in productsIds) {
            final productMap = await storage.read(
                tableName: storage.productsWishlistTable, key: id);
            products.add(Product.fromMap(productMap));
          }
          yield WishlistSucceed(products: products);
        } else {
          yield WishlistFailed(failure: failure);
        }
      }
    } else if (event is AddToWishlist) {
      yield WishlistLoading();
      final product = event.product;
      products.add(product);
      storage.write(
          tableName: storage.productsWishlistTable,
          key: product.id.toString(),
          value: product.toMap());
      yield WishlistSucceed(products: products);

      // add(GetWishlistProducts());
    } else if (event is RemoveFromWishlist) {
      yield WishlistLoading();
      final product = event.product;
      for (int i = 0; i < products.length; i++) {
        if (products[i].id == product.id) {
          products.removeAt(i);
          break;
        }
      }
      storage.delete(
        tableName: storage.productsWishlistTable,
        key: product.id.toString(),
      );
      yield WishlistSucceed(products: products);

//      add(GetWishlistProducts());
    }
  }

  Future<dynamic> getProductsId() async {
    return await storage.read(tableName: storage.productsWishlistTable);
  }
}
