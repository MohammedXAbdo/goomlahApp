part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}


class GetLocation extends LocationEvent{}

class GoToAppSettings extends LocationEvent{}

class GoToLocationSettings extends LocationEvent{}

