import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class HomeProductsBloc extends Bloc<HomeProductsEvent, HomeProductsState> {
  HomeProductsBloc({
    @required this.databaseImpl,
    @required this.storage,
  }) : super(ProductInitial());
  final DatabaseRepository databaseImpl;
  final LocalDatabaseRepository storage;

  @override
  Stream<HomeProductsState> mapEventToState(
    HomeProductsEvent event,
  ) async* {
    if (event is FetchingCategoryProducts) {
      yield* handleCategoryProducts(event);
    }
  }

  Stream<HomeProductsState> handleCategoryProducts(
      FetchingCategoryProducts event) async* {
    yield CategoryProductsLoading(categoryId: event.categoryId);
    try {
      if (!await Functions.getNetworkStatus()) {
        throw NetworkFailure();
      }
      final productsMap =
          (await databaseImpl.fetchHomeProducts(categoryId: event.categoryId));
      storage.write(
          tableName: storage.categoryProductsTable,
          key: event.categoryId.toString(),
          value: productsMap);
      yield CategoryProductsSucceed(
          products: await getProductsFromMap(productsMap));
    } on Failure catch (failure) {
      if (failure is NetworkFailure) {
        final localProductsMap = await storage.read(
            tableName: storage.categoryProductsTable,
            key: event.categoryId.toString());
        if (localProductsMap != null) {
          print(localProductsMap.toString());
          yield CategoryProductsSucceed(
              products: await getProductsFromMap(localProductsMap));
        } else {
          yield CategoryProductsFailed(failure: failure);
        }
      } else {
        yield CategoryProductsFailed(failure: failure);
      }
    }
  }

  Future<List<Product>> getProductsFromMap(dynamic productsMap) async {
    final List<Product> products = [];
    for (var productMap in productsMap) {
      if (productMap != null) {
        products.add(Product.fromMap(productMap));
      }
    }
    return products;
  }
}
