part of 'login_bloc.dart';

@immutable
sealed class LoginState extends Equatable {
  final List<LoginFieldError> errors;

  const LoginState({this.errors = const []});

  @override
  List<Object?> get props => [errors];
}

final class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

final class LoginLoading extends LoginState {
  const LoginLoading({super.errors = const []});

  @override
  List<Object?> get props => [errors];
}

final class NotLoggedIn extends LoginState {
  const NotLoggedIn({super.errors});

  @override
  List<Object?> get props => [errors];
}

final class LoggedIn extends LoginState {
  final UserEntity user;

  const LoggedIn({required this.user, super.errors = const []});

  @override
  List<Object?> get props => [user, errors];
}

final class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message, super.errors = const []});

  @override
  List<Object?> get props => [message, errors];
}
