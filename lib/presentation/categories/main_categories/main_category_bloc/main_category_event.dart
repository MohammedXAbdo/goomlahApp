part of 'main_category_bloc.dart';

@immutable
abstract class MainCategoryEvent {}

class FetchMainCategories extends MainCategoryEvent{
  final int page ;

  FetchMainCategories(this.page);
}
