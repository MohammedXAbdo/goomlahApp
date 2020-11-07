import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({@required this.storage}) : super(AuthInitial());

  final LocalDatabaseRepository storage;
  final String tokenKey = 'token';
  final String idKey = 'id';

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is CheckAuthEvent) {
      yield* handleCheckAuthentication();
    } else if (event is IsAuthEvent) {
      _isAuthenticated = true;
      yield IsAuthenticatedState();
    } else if (event is NotAuthEvent) {
      _isAuthenticated = false;
      yield NotAuthenticatedState();
    }
  }

  Stream<AuthState> handleCheckAuthentication() async* {
    yield AuthStateLoading();
    final token = await storage.read(key: tokenKey);
    final id = await storage.read(key: idKey);

    if (token == null || id == null) {
      yield NotAuthenticatedState();
      _isAuthenticated = false;
    } else {
      yield IsAuthenticatedState();
      _isAuthenticated = true;
    }
  }
}
