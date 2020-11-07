part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}


class AuthStateLoading extends AuthState{}

class IsAuthenticatedState extends AuthState{}

class NotAuthenticatedState extends AuthState{}
