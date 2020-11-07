import 'package:flutter/material.dart';
import 'package:goomlah/presentation/Register/bloc/account_bloc.dart';
import 'package:goomlah/presentation/Register/verification/bloc/verification_bloc.dart';
import 'package:goomlah/presentation/profile/bloc/profile_bloc.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/Failure/server_validation_error.dart';
import 'package:meta/meta.dart';

class RegisterServerValidator  {
  String setSignInError<@required T extends Failure>(AccountState state) {
    if (state is SignInFailed && state.failure is ServerValidationErrors) {
      return getServerError<T>(state);
    }
    return null;
  }

  String setSignUpError<@required T extends Failure>(AccountState state) {
    if (state is SignUpFailed && state.failure is ServerValidationErrors) {
      return getServerError<T>(state);
    }
    return null;
  }

  String setVerificationError<@required T extends Failure>(VerificationState state) {
    if (state is VerificationFailed && state.failure is ServerValidationErrors) {
      return getServerError<T>(state);
    }
    return null;
  }

  String getServerError<T>(state) {
    for (Failure failure in state.failure.failures) {
      if (failure is T) {
        return failure.code;
      }
    }
    return null;
  }

String setEditProfileError<@required T extends Failure>(ProfileState state) {
    if (state is EditProfileFailed && state.failure is ServerValidationErrors) {
      return getServerError<T>(state);
    }
    return null;
  }
}
