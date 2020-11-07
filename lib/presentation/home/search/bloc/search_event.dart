part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchByProduct extends SearchEvent {
  final String name;
  SearchByProduct({@required this.name})
      : assert(name != null, 'field shouldnt be null');
}

class ClearSearchPage extends SearchEvent {}

class ShowFailedState extends SearchEvent {
  final Failure failure;
  ShowFailedState({@required this.failure})
      : assert(failure != null, 'field mustnot be equall null');
}

class GetAllCategoreis extends SearchEvent {}
