part of 'main_category_bloc.dart';

@immutable
abstract class MainCategoriesState {
  final int currentPage = 0;
}

class MainCategoriesIntial extends MainCategoriesState {}

class MainCategoriesLoading extends MainCategoriesState {
  final int currentPage;

  MainCategoriesLoading({@required this.currentPage});
}

class MainCategoriesSucceed extends MainCategoriesState {
  final List<Category> categories;
  final int currentPage;
  final int lastPage;

  MainCategoriesSucceed(
      {@required this.currentPage,
      @required this.lastPage,
      @required this.categories})
      : assert(categories != null, 'field mustnot be equall null'),
        assert(lastPage != null, 'field mustnot be equall null'),
        assert(currentPage != null, 'field mustnot be equall null');
}

class MainCategoriesFailed extends MainCategoriesState {
  final Failure failure;
  final int currentPage;

  MainCategoriesFailed({@required this.currentPage, @required this.failure})
      : assert(failure != null, 'field mustnot be equall null');
}
