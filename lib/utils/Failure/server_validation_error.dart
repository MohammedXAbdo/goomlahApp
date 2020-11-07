
import 'failure.dart';

class ServerValidationErrors extends Failure {
  final code;
  ServerValidationErrors(this.failures, {this.code = 'Server errors'})
      : super('code') ;
  final List<Failure> failures;
}

class NameValidationError extends Failure {
  final String code;
  NameValidationError(this.code) : super(code);
}

class VerificationValidationError extends Failure {
  final String code;
  VerificationValidationError(this.code) : super(code);
}

class PasswordValidationError extends Failure {
  final String code;
  PasswordValidationError(this.code) : super(code);
}

class PhoneValidationError extends Failure {
  final String code;
  PhoneValidationError(this.code) : super(code);
}

class AddressValidationError extends Failure {
  final String code;
  AddressValidationError(this.code) : super(code);
}
