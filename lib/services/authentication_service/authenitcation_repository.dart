import 'package:goomlah/services/api_handler.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationRepository {
  final ApiHandler apiHandler;

  AuthenticationRepository(this.apiHandler);
  Future<Map<String, dynamic>> signIn(
      {@required String phone, @required String password});
  Future<Map<String, dynamic>> signUp(
      {@required String name,
      @required String phone,
      @required String password,
      @required double latitude,
      @required double longitude,
      @required String passwordConfirmation,
      @required String address});
  Future<String> getVerificationCode({@required String token});
  Future<void> postVerificationCode(
      {@required String token, @required String code});
}
