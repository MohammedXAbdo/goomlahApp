part of 'account_bloc.dart';

@immutable
abstract class AccountState {}

class Loading extends AccountState {}

class FailedState extends AccountState {
  final Failure failure;
  FailedState(this.failure)
      : assert(failure != null, 'field mustnot be equal null');
}

class AccountInitial extends AccountState {}

class SignInLoading extends Loading {}

class SignInSucceed extends AccountState {}

class SignInFailed extends FailedState {
  SignInFailed(failure) : super(failure);
}

class SignUpLoading extends Loading {}

class SignUpSucceed extends AccountState {}

class SignUpFailed extends FailedState {
  SignUpFailed(failure) : super(failure);
}






class LogoutLoading extends Loading {}

class LogoutSucceed extends AccountState {}

class LogoutFailed extends FailedState {
  LogoutFailed(Failure failure) : super(failure);
}
