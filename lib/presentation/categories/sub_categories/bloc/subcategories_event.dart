part of 'subcategories_bloc.dart';

@immutable
abstract class SubCategoriesEvent {}

class FetchingSubCategories extends SubCategoriesEvent {
  final int page;
  final int categoryID;

  FetchingSubCategories({@required this.page, @required this.categoryID});
}
