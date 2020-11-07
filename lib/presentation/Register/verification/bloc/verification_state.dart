part of 'verification_bloc.dart';

@immutable
abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class GetVerficationSucceed extends VerificationState {
  final String verificationCode;

  GetVerficationSucceed(this.verificationCode);
}

class PostVerficationSucceed extends VerificationState {}

class VerificationFailed extends VerificationState {
  final Failure failure;
  VerificationFailed(this.failure);
}
