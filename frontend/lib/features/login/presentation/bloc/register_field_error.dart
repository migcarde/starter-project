enum RegisterFieldError {
  emailRequired,
  emailNotValid,
  emailAlreadyRegistered,
  nameRequired,
  passwordRequired,
  passwordNotValid,
  unknown;

  String get message => switch (this) {
        RegisterFieldError.emailRequired => 'Email is required',
        RegisterFieldError.emailNotValid => 'Email is not valid',
        RegisterFieldError.emailAlreadyRegistered => 'Email already registered',
        RegisterFieldError.nameRequired => 'Name is required',
        RegisterFieldError.passwordRequired => 'Password is required',
        RegisterFieldError.passwordNotValid => 'Password is not valid',
        RegisterFieldError.unknown => 'Unknown error',
      };
}

extension LoginFieldsErrorExtensions on List<RegisterFieldError> {
  String? get getEmailError {
    if (contains(RegisterFieldError.emailRequired)) {
      return RegisterFieldError.emailRequired.message;
    }
    if (contains(RegisterFieldError.emailNotValid)) {
      return RegisterFieldError.emailNotValid.message;
    }
    if (contains(RegisterFieldError.emailAlreadyRegistered)) {
      return RegisterFieldError.emailAlreadyRegistered.message;
    }

    return null;
  }

  String? get getNameError {
    if (contains(RegisterFieldError.nameRequired)) {
      return RegisterFieldError.nameRequired.message;
    }

    return null;
  }

  String? get getPasswordError {
    if (contains(RegisterFieldError.passwordRequired)) {
      return RegisterFieldError.passwordRequired.message;
    }
    if (contains(RegisterFieldError.passwordNotValid)) {
      return RegisterFieldError.passwordNotValid.message;
    }
    return null;
  }
}
