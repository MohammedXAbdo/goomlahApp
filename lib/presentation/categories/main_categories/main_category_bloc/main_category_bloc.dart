import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/model/category.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'main_category_event.dart';
part 'main_category_state.dart';

class MainCategoriesBloc extends Bloc<MainCategoryEvent, MainCategoriesState> {
  MainCategoriesBloc({@required this.storage, @required this.databaseImpl})
      : super(MainCategoriesIntial());
  final DatabaseRepository databaseImpl;
  final LocalDatabaseRepository storage;
  @override
  Stream<MainCategoriesState> mapEventToState(
    MainCategoryEvent event,
  ) async* {
    if (event is FetchMainCategories) {
      yield MainCategoriesLoading(currentPage: event.page);
      try {
        if (!await Functions.getNetworkStatus()) {
          throw NetworkFailure();
        }
        final pageData =
            await databaseImpl.fetchMainCategories(page: event.page);
        yield* getSucceedState(pageData);
        storage.write(
            tableName: storage.mainCategoriesTable,
            key: event.page.toString(),
            value: pageData);
      } on Failure catch (failure) {
        if (failure is NetworkFailure) {
          final pageData = await storage.read(
              tableName: storage.mainCategoriesTable,
              key: event.page.toString());
          if (pageData != null) {
            yield* getSucceedState(pageData);
          } else {
            yield MainCategoriesFailed(
                currentPage: event.page, failure: failure);
          }
        } else {
          yield MainCategoriesFailed(currentPage: event.page, failure: failure);
        }
      }
    }
  }

  Stream<MainCategoriesState> getSucceedState(final pageData) async* {
    final categoriesMap = pageData[databaseImpl.categoriesKey];
    List<Category> categories = [];
    for (var categoryMap in categoriesMap) {
      if (categoryMap != null) {
        categories.add(Category.fromMap(categoryMap));
      }
    }
    yield MainCategoriesSucceed(
        categories: categories,
        currentPage: pageData[databaseImpl.currentPageKey],
        lastPage: pageData[databaseImpl.lastPageKey]);
  }
}
