part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileEditingLoading extends ProfileState {}

class ProfileFetchingSucceed extends ProfileState {
  final User user;

  ProfileFetchingSucceed({this.user});
}

class ProfileFetchingFailed extends ProfileState {
  final Failure failure;

  ProfileFetchingFailed({@required this.failure});
}

class EditProfileSucceed extends ProfileState {
  final String successMessage;

  EditProfileSucceed({@required this.successMessage});
}

class EditProfileFailed extends ProfileState {
  final Failure failure;

  EditProfileFailed({@required this.failure});
}
