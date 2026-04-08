enum LoginFieldError {
  emailRequired,
  emailNotValid,
  emailAlreadyRegistered,
  passwordRequired,
  passwordNotValid,
  invalidCredentials,
  unknown;

  String get message => switch (this) {
        LoginFieldError.emailRequired => 'Email is required',
        LoginFieldError.emailNotValid => 'Email is not valid',
        LoginFieldError.emailAlreadyRegistered => 'Email already registered',
        LoginFieldError.passwordRequired => 'Password is required',
        LoginFieldError.passwordNotValid => 'Password is not valid',
        LoginFieldError.invalidCredentials => 'Invalid credentials',
        LoginFieldError.unknown => 'Unknown error',
      };
}

extension LoginFieldsErrorExtensions on List<LoginFieldError> {
  String? get getEmailError {
    if (contains(LoginFieldError.emailRequired)) {
      return LoginFieldError.emailRequired.message;
    }
    if (contains(LoginFieldError.emailNotValid)) {
      return LoginFieldError.emailNotValid.message;
    }
    if (contains(LoginFieldError.emailAlreadyRegistered)) {
      return LoginFieldError.emailAlreadyRegistered.message;
    }

    return null;
  }

  String? get getPasswordError {
    if (contains(LoginFieldError.passwordRequired)) {
      return LoginFieldError.passwordRequired.message;
    }
    if (contains(LoginFieldError.passwordNotValid)) {
      return LoginFieldError.passwordNotValid.message;
    }
    if (contains(LoginFieldError.invalidCredentials)) {
      return LoginFieldError.invalidCredentials.message;
    }
    return null;
  }
}
