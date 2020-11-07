part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSucceed extends LocationState {
  final double latitude;
  final double longitude;
  final String location;
  LocationSucceed({
    @required this.location,
    @required this.latitude,
    @required this.longitude,
  });
}

class Locationfailed extends LocationState {
  final Failure failure;

  Locationfailed({@required this.failure});
}
