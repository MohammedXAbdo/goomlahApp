import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/presentation/profile/Auth_bloc/auth_bloc.dart';
import 'package:goomlah/services/authentication_service/authenitcation_repository.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc(
      {@required this.authRep, @required this.authBloc, @required this.storage})
      : super(AccountInitial());

  final AuthenticationRepository authRep;
  final LocalDatabaseRepository storage;
  final AuthBloc authBloc;
  final String tokenKey = 'token';
  final String idKey = 'id';

  @override
  Future<void> close() {
    authBloc.close();
    return super.close();
  }

  @override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is SignInEvent) {
      yield* handleSignInEvent(event);
    } else if (event is SignUpEvent) {
      yield* handleSignUpEvent(event);
    } else if (event is ResetAccountState) {
      yield AccountInitial();
    } else if (event is LogoutEvent) {
      yield* handleLogoutEvent();
    }
  }

  Stream<AccountState> handleLogoutEvent() async* {
    yield LogoutLoading();
    try {
      // todo : call logout api
      await storage.delete(key: tokenKey);
      await storage.delete(key: idKey);
      authBloc.add(NotAuthEvent());
      yield LogoutSucceed();
    } on Failure catch (e) {
      yield LogoutFailed(e);
    }
  }

  // try to call sign in api and save the returned token and user id to local storage
  Stream<AccountState> handleSignInEvent(SignInEvent event) async* {
    yield SignInLoading();
    try {
      if (!await Functions.getNetworkStatus()) {
        throw (NetworkFailure());
      }
      final response =
          await authRep.signIn(phone: event.phone, password: event.password);
      await storage.write(key: tokenKey, value: response[tokenKey]);
      await storage.write(key: idKey, value: response[idKey]);
      authBloc.add(IsAuthEvent());
      yield SignInSucceed();
    } on Failure catch (failure) {
      print(failure);
      yield SignInFailed(failure);
    }
  }
  // try to call sign up api and save the returned token to local storage

  Stream<AccountState> handleSignUpEvent(SignUpEvent event) async* {
    yield SignUpLoading();
    try {
      if (!await Functions.getNetworkStatus()) {
        yield SignUpFailed(NetworkFailure());
      }
      final response = await authRep.signUp(
          latitude: event.latitude,
          longitude: event.longitude,
          phone: event.phone,
          password: event.password,
          address: event.address,
          name: event.name,
          passwordConfirmation: event.passwordConfirmation);
      await storage.write(key: tokenKey, value: response[tokenKey]);
      await storage.write(key: idKey, value: response[idKey]);
      authBloc.add(IsAuthEvent());
      yield SignUpSucceed();
    } on Failure catch (failure) {
      yield SignUpFailed(failure);
    }
  }
}
