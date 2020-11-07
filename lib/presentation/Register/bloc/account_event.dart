part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}

class SignInEvent extends AccountEvent {
  final String phone;
  final String password;

  SignInEvent({@required this.phone, @required this.password})
      : assert(phone != null, 'field mustnot be equal null'),
        assert(password != null, 'field mustnot be equal null');
}

class SignUpEvent extends AccountEvent {
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String address;
  final String name;
  final double longitude;
  final double latitude;
  SignUpEvent(
      {@required this.passwordConfirmation,
      @required this.name,
      @required this.phone,
      @required this.latitude,
      @required this.longitude,
      @required this.password,
      @required this.address})
      : assert(phone != null, 'field mustnot be equal null'),
        assert(password != null, 'field mustnot be equal null'),
        assert(name != null, 'field mustnot be equal null'),
        assert(address != null, 'field mustnot be equal null');
}

class ResetAccountState extends AccountEvent {}


class LogoutEvent extends AccountEvent {}
