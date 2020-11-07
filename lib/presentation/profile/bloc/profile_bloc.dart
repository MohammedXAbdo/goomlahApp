import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:goomlah/model/user.dart';
import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:goomlah/services/online_database_service/database_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/functions/functions.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({@required this.databaseImpl, @required this.storage})
      : super(ProfileInitial());
  final DatabaseRepository databaseImpl;
  final LocalDatabaseRepository storage;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is FetchingProfile) {
      yield* handleFetchingEvent(event);
    } else if (event is EditingProfile) {
      yield* handleEditingEvent(event);
    }
  }

  Stream<ProfileState> handleFetchingEvent(FetchingProfile event) async* {
    yield ProfileLoading();
    try {
      if (!await Functions.getNetworkStatus()) {
        throw NetworkFailure();
      }
      final userId = await storage.read(key: storage.idKey);
      final token = await storage.read(key: storage.tokenKey);
      if (userId == null || token == null) {
        yield ProfileFetchingFailed(failure: UnimplementedFailure());
      } else {
        final userMap =
            await databaseImpl.fetchProfile(userId: userId, token: token);
        // TODO : he should make lat and long double not int
        final user = User.fromMap(userMap, address: "Cairo");
        storage.write(
            tableName: storage.profileTable,
            key: storage.profileKey,
            value: user.toMap());
        storage.write(
            tableName: storage.profileTable,
            key: storage.welcomeMessageKey,
            value: userMap);
        yield ProfileFetchingSucceed(user: user);
      }
    } on Failure catch (failure) {
      if (failure is NetworkFailure) {
        final welcomeMessage = await storage.read(
            tableName: storage.profileTable, key: storage.welcomeMessageKey);
        final userMap = await storage.read(
            tableName: storage.profileTable, key: storage.profileKey);
        final user = User.fromMap(userMap);
        if (welcomeMessage != null && userMap != null) {
          yield ProfileFetchingSucceed(user: user);
        } else {
          yield ProfileFetchingFailed(failure: failure);
        }
      } else {
        yield ProfileFetchingFailed(failure: failure);
      }
    }
  }

  Stream<ProfileState> handleEditingEvent(EditingProfile event) async* {
    yield ProfileEditingLoading();
    try {
      if (!await Functions.getNetworkStatus()) {
        throw NetworkFailure();
      }
      final userId = await storage.read(key: storage.idKey);
      final token = await storage.read(key: storage.tokenKey);
      if (userId == null || token == null) {
        yield EditProfileFailed(failure: UnimplementedFailure());
      } else {
        final String responseMessage = await databaseImpl.editProfile(
            token: token,
            id: userId.toString(),
            name: event.name,
            phone: event.phone,
            password: event.password);
        add(FetchingProfile());
        yield EditProfileSucceed(successMessage: responseMessage);
      }
    } on Failure catch (failure) {
      yield EditProfileFailed(failure: failure);
    }
  }
}
