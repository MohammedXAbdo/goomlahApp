import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/model/product.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';
import 'package:easy_localization/easy_localization.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({@required this.databaseImpl}) : super(SearchInitial());
  final DatabaseRepository databaseImpl;
  int selectedCategoryid = -1; // no categorySelected by default
  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchByProduct) {
      yield ProductsSearchLoading();
      try {
        if (event.name.length < 1) {
          yield ProductsSearchEmpty();
        } else {
          if (!await Functions.getNetworkStatus()) {
            throw (NetworkFailure());
          } else {
            dynamic products =
                await databaseImpl.searchByProduct(productName: event.name);

            if (products.length < 1) {
              yield ProductsSearchSucceed(products: products);
            } else {
              yield ProductsSearchSucceed(products: products);
            }
          }
        }
      } on Failure catch (failure) {
        yield ProductsSearchFailed(failure: failure);
      }
    } else if (event is ClearSearchPage) {
      yield ProductsSearchEmpty();
    } else if (event is ShowFailedState) {
      yield ProductsSearchFailed(failure: event.failure);
    } else if (event is GetAllCategoreis) {
      yield AllCategoriesLoading();
      try {
        if (!await Functions.getNetworkStatus()) {
          throw (NetworkFailure());
        }
        final categoriesMap = (await databaseImpl.fetchMainCategories(
            page: 1))[databaseImpl.categoriesKey];
        List<Category> categories = [];
        for (var categoryMap in categoriesMap) {
          if (categoryMap != null) {
            categories.add(Category.fromMap(categoryMap));
          }
        }
        yield AllCategoriesSucceed(categories: categories);
      } on Failure catch (failure) {
        yield ProductsSearchFailed(failure: failure);
      }
    }
  }

  Future<dynamic> searchByProduct(String pattern) async {
    try {
      if (!await Functions.getNetworkStatus()) {
        throw (NetworkFailure());
      }
      List<Product> products = await databaseImpl.searchByProduct(
          productName: pattern, categoryId: selectedCategoryid);
          
      return products;
    } on Failure catch (failure) {
      add(ShowFailedState(failure: failure));
      return "error";
    }
  }
}
