part of 'page_bloc.dart';

@immutable
abstract class PageEvent {}

class PageTransition extends PageEvent {
  final PageType pageType;

  PageTransition(this.pageType);
}

class GoToPayment extends PageEvent {
  final Map<String, int> itemsCount;
  final double totalPrice;
  GoToPayment({@required this.itemsCount, @required this.totalPrice});
}

class GoToSubCategory extends PageEvent {
  final Category category;
  final Category mainCategory;
  final PageType previousPage;

  GoToSubCategory({this.category, this.mainCategory, this.previousPage});
}
