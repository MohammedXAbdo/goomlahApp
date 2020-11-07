import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:goomlah/services/authentication_service/authenitcation_repository.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc({@required this.storage, @required this.authRep})
      : super(VerificationInitial());
  final LocalDatabaseRepository storage;
  final AuthenticationRepository authRep;

  @override
  Stream<VerificationState> mapEventToState(
    VerificationEvent event,
  ) async* {
    if (event is GetVerficationEvent) {
      yield* getVerficationEvent(event);
    } else if (event is PostVerficationEvent) {
      yield* postVerficationEvent(event);
    }
  }

  Stream<VerificationState> getVerficationEvent(
      GetVerficationEvent event) async* {
    yield VerificationLoading();
    try {
      if (!await Functions.getNetworkStatus()) {
        throw NetworkFailure();
      }
      final String token = await storage.read(key: storage.tokenKey);
      if (token == null) {
        yield VerificationFailed(UnimplementedFailure());
      } else {
        final verificationCode =
            await authRep.getVerificationCode(token: token);
        yield GetVerficationSucceed(verificationCode);
      }
    } on Failure catch (failure) {
      yield VerificationFailed(failure);
    }
  }

  Stream<VerificationState> postVerficationEvent(
      PostVerficationEvent event) async* {
    yield VerificationLoading();
    try {
      if (!await Functions.getNetworkStatus()) {
        throw NetworkFailure();
      }
      final String token = await storage.read(key: storage.tokenKey);
      if (token == null) {
        yield VerificationFailed(UnimplementedFailure());
      } else {
        Future.delayed(Duration(seconds: 1));
        // await authRep.postVerificationCode(
        //     token: token, code: event.submittedCode);
        
        yield PostVerficationSucceed();
      }
    } on Failure catch (failure) {
      yield VerificationFailed(failure);
    }
  }
}
