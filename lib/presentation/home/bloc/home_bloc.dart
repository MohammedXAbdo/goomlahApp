import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeblocEvent, HomeblocState> {
  HomeBloc({@required this.databaseImpl, @required this.storage})
      : super(HomeblocInitial());
  final DatabaseRepository databaseImpl;
  final LocalDatabaseRepository storage;

  @override
  Stream<HomeblocState> mapEventToState(
    HomeblocEvent event,
  ) async* {
    if (event is FetchHomeData) {
      yield HomeDataLoading();
      try {
        if (!await Functions.getNetworkStatus()) {
          throw NetworkFailure();
        }
        final map = await databaseImpl.fetchHomeData();
        final subCategoriesMap = map[databaseImpl.categoriesKey];
        final productsMap = map[databaseImpl.productsKey];
        final mainCategoriesMap = (await databaseImpl.fetchMainCategories(
            page: 1))[databaseImpl.categoriesKey];
        storage.write(
            tableName: storage.homeSubCategoriesTable,
            key: databaseImpl.categoriesKey,
            value: subCategoriesMap);
        storage.write(
            tableName: storage.lastProductsTable,
            key: databaseImpl.productsKey,
            value: productsMap);
        storage.write(
            tableName: storage.homeMainCategoriesTable,
            key: databaseImpl.categoriesKey,
            value: mainCategoriesMap);

        yield* fetchingSucceed(
            getCategoriesFromMap(subCategoriesMap),
            getCategoriesFromMap(mainCategoriesMap),
            getProductsFromMap(productsMap));
      } on Failure catch (failure) {
        if (failure is NetworkFailure) {
          final localCategoriesMap = await storage.read(
              tableName: storage.homeSubCategoriesTable,
              key: databaseImpl.categoriesKey);
          final localproductsMap = await storage.read(
              tableName: storage.lastProductsTable,
              key: databaseImpl.productsKey);
          final localMainCategoriesMap = await storage.read(
              tableName: storage.homeMainCategoriesTable,
              key: databaseImpl.categoriesKey);
          if (localCategoriesMap != null &&
              localproductsMap != null &&
              localMainCategoriesMap != null) {
            yield* fetchingSucceed(
                getCategoriesFromMap(localCategoriesMap),
                getCategoriesFromMap(localMainCategoriesMap),
                getProductsFromMap(localproductsMap));
          } else {
            yield* fetchingFailed(failure);
          }
        } else {
          yield* fetchingFailed(failure);
        }
      }
    }
  }

  Stream<HomeblocState> fetchingSucceed(List<Category> subCategories,
      List<Category> mainCategories, List<Product> products) async* {
    yield HomeDataSucceed(
        subCategories: subCategories,
        products: products,
        mainCategories: mainCategories);
  }

  Stream<HomeblocState> fetchingFailed(Failure failure) async* {
    yield HomeDataFailed(failure: failure);
  }

  List<Category> getCategoriesFromMap(dynamic categoriesMap) {
    List<Category> categories = [];
    for (var categoryMap in categoriesMap) {
      if (categoryMap != null) {
        categories.add(Category.fromMap(categoryMap));
      }
    }
    return categories;
  }

  List<Product> getProductsFromMap(dynamic productsMap) {
    final List<Product> products = [];
    for (var productMap in productsMap) {
      if (productMap != null) {
        products.add(Product.fromMap(productMap));
      }
    }
    return products;
  }
}
