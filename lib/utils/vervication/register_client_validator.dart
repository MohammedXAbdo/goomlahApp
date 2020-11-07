import 'package:easy_localization/easy_localization.dart';

class RegisterClientValidator {
  final String emptyPhone = 'empty_phone'.tr();
  final String emptyPassword = 'empty_password'.tr();

  String phoneValidator(String phone) {
    if (phone.isEmpty) {
      return emptyPhone;
    }
    return null;
  }
}

class SignInCLientValidator extends RegisterClientValidator {
  String passwordValidator(String password) {
    if (password.isEmpty) {
      return emptyPassword;
    }
    return null;
  }
}

class SignUpCLientValidator extends RegisterClientValidator {
  static final String emptyName = 'empty_name'.tr();
  static final String emptyAddress = 'empty_address'.tr();
  static final String emptyConfirmPassword = 'empty_confirm_password'.tr();
  static final String passwordsNotMatched = 'passwords_not_matched'.tr();
  final String shortPassword = 'short_password'.tr() + ".";

  String nameValidator(String name) {
    if (name.isEmpty) {
      return emptyName;
    }
    return null;
  }

  String passwordValidator(String password) {
    if (password.isEmpty) {
      return emptyPassword;
    } else if (password.length < 6) {
      return shortPassword;
    }
    return null;
  }

  String addressValidator(String address) {
    if (address.isEmpty) {
      return emptyAddress;
    }
    return null;
  }

  String confirmPassword(String firstPassword, String secondPassword) {
    if (secondPassword.isEmpty) {
      return emptyConfirmPassword;
    }
    if (firstPassword != secondPassword) {
      return passwordsNotMatched;
    }

    return null;
  }
}

class VerificationClientValidator {
  final String emptyCode = 'empty_code'.tr();
  final String codesNotMatch = 'codes_not_match'.tr();

  String codeValidator(String code, {String actualCode}) {
    if (code.isEmpty) {
      return emptyCode;
    }
    if (actualCode != null) {
      if (code != actualCode) {
        return codesNotMatch;
      }
    }
    return null;
  }
}

class EditProfileValidator {
  static final String passwordsNotMatched = 'passwords_not_matched'.tr();
  static final String emptyName = 'empty_name'.tr();
  final String emptyPhone = 'empty_phone'.tr();
  final String shortPassword = 'short_password'.tr() + ".";

  String shortPasswordValidator(String password) {
    if (password.length >=1 && password.length < 6) {
      return shortPassword;
    }
    return null;
  }

  String confirmPassword(String firstPassword, String secondPassword) {
    if (firstPassword != null && secondPassword != null) {
      if (firstPassword.trim() != secondPassword) {
        return passwordsNotMatched;
      }
    }

    return null;
  }

  String nameValidator(String name) {
    if (name.isEmpty) {
      return emptyName;
    }
    return null;
  }

  String phoneValidator(String phone) {
    if (phone.isEmpty) {
      return emptyPhone;
    }
    return null;
  }
}
