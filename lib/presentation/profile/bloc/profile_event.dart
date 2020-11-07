part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class FetchingProfile extends ProfileEvent {}

class EditingProfile extends ProfileEvent {
  final String name;
  final String phone;
  final String password;

  EditingProfile({@required this.name, @required this.phone, this.password});
}
