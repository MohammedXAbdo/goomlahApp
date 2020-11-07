part of 'verification_bloc.dart';

@immutable
abstract class VerificationEvent {}

class PostVerficationEvent extends VerificationEvent {
  final String submittedCode;

  PostVerficationEvent({
    @required this.submittedCode,
  });
}

class GetVerficationEvent extends VerificationEvent {}
