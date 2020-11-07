part of 'home_bloc.dart';

@immutable
abstract class HomeblocState {}

class HomeblocInitial extends HomeblocState {}

class HomeDataLoading extends HomeblocState {}

class HomeDataSucceed extends HomeblocState {
  final List<Product> products;
  final List<Category> subCategories;
  final List<Category> mainCategories;

  HomeDataSucceed(
      {@required this.mainCategories,
      @required this.products,
      @required this.subCategories});
}

class HomeDataFailed extends HomeblocState {
  final Failure failure;

  HomeDataFailed({@required this.failure})
      : assert(failure != null, 'field mustnot be equall null');
}
