import 'dart:convert';
import 'package:goomlah/services/api_handler.dart';
import 'package:goomlah/services/authentication_service/authenitcation_repository.dart';
import 'package:goomlah/utils/Failure/failure.dart';
import 'package:goomlah/utils/Failure/server_validation_error.dart';

class AuthImpl extends AuthenticationRepository {
  AuthImpl(ApiHandler apiHandler) : super(apiHandler);
  final String loginPath = 'public/api/users/login';
  final String signUpPath = 'public/api/users';
  final String verificationPath = 'public/api/users/verify';
  final String verificationKey = 'activationCode';
  final String phoneField = 'phone';
  final String passwordField = 'password';
  final String addressField = 'address';
  final String latitudeField = 'latitude';
  final String longitudeField = 'longitude';
  final String passwordConfirmationField = 'password_confirmation';
  final String nameField = 'name';
  final String loginEndpoint = 'users/login';
  final String registerEndpoint = 'users';
  final String messageKey = 'message';
  final String tokenKey = 'token';
  final String userKey = 'user';
  final String idKey = 'id';

  @override
  Future<Map<String, dynamic>> signIn({String phone, String password}) async {
    try {
      final body = {phoneField: phone, passwordField: password};
      final response = await apiHandler.postData(path: loginPath, body: body);

      final responseBody = json.decode(response.body);
      if (apiHandler.successResponse(response.statusCode)) {
        String token = json.decode(response.body)[tokenKey];
        String id = (json.decode(response.body)[userKey][idKey]).toString();
        return {tokenKey: token, idKey: id};
      } else {
        print('auth failed');
        throw ServerValidationErrors(
            [PhoneValidationError(responseBody[messageKey])]);
      }
    } on ServerValidationErrors {
      rethrow;
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  // get the token from the Api during signUp
  @override
  Future<Map<String, dynamic>> signUp({
    String name,
    String phone,
    String password,
    String passwordConfirmation,
    String address,
    double longitude,
    double latitude,
  }) async {
    try {
      final body = {
        latitudeField: latitude.toString(),
        longitudeField: longitude.toString(),
        nameField: name,
        phoneField: phone,
        passwordField: password,
        passwordConfirmationField: passwordConfirmation
      };
      final response = await apiHandler.postData(path: signUpPath, body: body);

      final responseBody = json.decode(response.body);
      if (apiHandler.successResponse(response.statusCode)) {
        String token = json.decode(response.body)[tokenKey];
        String id = (json.decode(response.body)[userKey][idKey]).toString();
        return {tokenKey: token, idKey: id};
      } else {
        if (response.statusCode == 401) {
          final messagesList = responseBody[messageKey];
          throw getAuthErrors(messagesList);
        } else {
          throw UnimplementedFailure();
        }
      }
    } on ServerValidationErrors {
      rethrow;
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  Failure getAuthErrors(final dynamic errorMessages) {
    List<Failure> failures = [];
    if (errorMessages == null) return UnimplementedFailure();
    errorMessages.forEach((key, value) {
      failures.add(mapFieldToFailure(key, value[0]));
    });

    if (failures.length < 1) {
      return UnimplementedFailure();
    } else {
      return ServerValidationErrors(failures);
    }
  }

  Failure mapFieldToFailure(String field, String errorMessage) {
    if (field == passwordField) {
      return PasswordValidationError(errorMessage);
    } else if (field == phoneField) {
      return PhoneValidationError(errorMessage);
    } else if (field == addressField) {
      return AddressValidationError(errorMessage);
    } else if (field == nameField) {
      return NameValidationError(errorMessage);
    }
    return NameValidationError(errorMessage);
  }

  @override
  Future<String> getVerificationCode({String token}) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      final headers = {"Authorization": "Bearer $token"};
      final response =
          await apiHandler.getData(path: verificationPath, headers: headers);
      if (apiHandler.successResponse(response.statusCode)) {
        return json.decode(response.body)[verificationKey];
      } else {
        throw UnimplementedFailure();
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }

  @override
  Future<void> postVerificationCode({String token, String code}) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      final headers = {"Authorization": "Bearer $token"};
      final body = {"activationCode": code};
      final response = await apiHandler.postData(
          path: verificationPath, headers: headers, body: body);
      if (apiHandler.successResponse(response.statusCode)) {
      } else {
        throw UnimplementedFailure();
        // throw ServerValidationErrors([
        //   VerificationValidationError(json.decode(response.body)[messageKey])
        // ]);
      }
    } on UnimplementedFailure {
      rethrow;
    } catch (e) {
      print(e);
      throw UnimplementedFailure();
    }
  }
}
