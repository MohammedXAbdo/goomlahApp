import 'package:easy_localization/easy_localization.dart';

abstract class Failure {
  final String code;
  Failure(this.code);
  List<Failure> failures;
}

class UnimplementedFailure extends Failure {
  final String code = "snack_bar_message".tr() + " !";
  UnimplementedFailure({code}) : super(code);
}

class NetworkFailure extends Failure {
  final code = "network_error".tr() + " !";
  NetworkFailure({code}) : super(code);
}

class LocationDeniedOnce extends Failure {
  final code = "location_access_denied".tr() + " !";
  LocationDeniedOnce({String code}) : super(code);
}

class LocationDeniedForever extends Failure {
  final code = "location_access_denied".tr() + " !";
  LocationDeniedForever({String code}) : super(code);
}

class LocationServiceDisabled extends Failure {
  final code = "location_access_denied".tr() + " !";
  LocationServiceDisabled({String code}) : super(code);
}
