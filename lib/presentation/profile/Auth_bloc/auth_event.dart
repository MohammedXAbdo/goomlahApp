part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}


class CheckAuthEvent extends AuthEvent {}

class NotAuthEvent extends AuthEvent {}

class IsAuthEvent extends AuthEvent {}
