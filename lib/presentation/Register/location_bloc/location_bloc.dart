import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:bloc/bloc.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';
import 'package:geocoder/geocoder.dart';
part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial());

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is GetLocation) {
      yield LocationLoading();
      try {
        if (!await Functions.getNetworkStatus()) {
          throw NetworkFailure();
        }
        bool enabled = await isLocationServiceEnabled();
        if (!enabled) {
          add(GoToLocationSettings());
          yield Locationfailed(failure: LocationServiceDisabled());
        } else {
          Position position =
              await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
          final coordinates =
              new Coordinates(position.latitude, position.longitude);
          final addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          final first = addresses.first;
          
          LocationPermission permission = await checkPermission();
          if (permission == LocationPermission.deniedForever) {
            add(GoToAppSettings());
          } else {
            yield LocationSucceed(
              location: first.locality,
              latitude: position.latitude,
              longitude: position.longitude,
            );
          }
        }
      } on Failure catch (failure) {
        yield Locationfailed(failure: failure);
      }
    } else if (event is GoToAppSettings) {
      await openAppSettings();
    } else if (event is GoToLocationSettings) {
      await openLocationSettings();
    }
  }
}
