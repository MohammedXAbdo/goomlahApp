import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'subcategories_event.dart';
part 'subcategories_state.dart';

class SubCategoriesBloc extends Bloc<SubCategoriesEvent, SubCategoriesState> {
  SubCategoriesBloc({@required this.databaseImpl})
      : super(SubCategoriesInitial());
  final DatabaseRepository databaseImpl;
  @override
  Stream<SubCategoriesState> mapEventToState(
    SubCategoriesEvent event,
  ) async* {
    if (event is FetchingSubCategories) {
      yield SubCategoriesLoading(
          categoryId: event.categoryID, currentPage: event.page);
      try {
        if (!await Functions.getNetworkStatus()) {
          throw NetworkFailure();
        }
        final data = await databaseImpl.fetchSubCategories(
            categoryId: event.categoryID, page: event.page);
        final categoriesMap = data[databaseImpl.categoriesKey];
        final productsMap = data[databaseImpl.productsKey];
        if (categoriesMap != null && productsMap != null) {
          List<Category> categories = getCategoriesList(categoriesMap);
          List<Product> products = getProductsList(productsMap);
          yield CategoriesAndProducts(
              products: products,
              currentPage: data[databaseImpl.currentPageKey],
              lastPage: data[databaseImpl.lastPageKey],
              categoryId: event.categoryID,
              categories: categories);
        } else if (categoriesMap != null) {
          List<Category> categories = getCategoriesList(categoriesMap);
          yield ContainCategories(
              currentPage: data[databaseImpl.currentPageKey],
              lastPage: data[databaseImpl.lastPageKey],
              categoryId: event.categoryID,
              categories: categories);
        } else if (productsMap != null) {
          List<Product> products = getProductsList(productsMap);
          yield ContainProducts(
              currentPage: data[databaseImpl.currentPageKey],
              lastPage: data[databaseImpl.lastPageKey],
              categoryId: event.categoryID,
              products: products);
        } else {
          throw UnimplementedFailure();
        }
      } on Failure catch (failure) {
        yield SubCategoriesFailed(
            categoryId: event.categoryID,
            currentPage: event.page,
            failure: failure);
      }
    }
  }

  List<Category> getCategoriesList(dynamic categoriesMap) {
    List<Category> categories = [];
    for (var categoryMap in categoriesMap) {
      if (categoryMap != null) {
        categories.add(Category.fromMap(categoryMap));
      }
    }
    return categories;
  }

  List<Product> getProductsList(dynamic productsMap) {
    List<Product> products = [];
    for (var productMap in productsMap) {
      if (productMap != null) {
        products.add(Product.fromMap(productMap));
      }
    }
    return products;
  }
}
