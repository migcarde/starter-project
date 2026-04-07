import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:news_app_clean_architecture/core/extensions/string_extensions.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/login/domain/entities/sign_in_with_email_and_password_params.dart';
import 'package:news_app_clean_architecture/features/login/domain/entities/user.dart';
import 'package:news_app_clean_architecture/features/login/domain/usecases/login_stream.dart';
import 'package:news_app_clean_architecture/features/login/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:news_app_clean_architecture/features/login/domain/usecases/sign_out.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_field_error.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginStreamUseCase _loginStreamUseCase;
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;
  final SignOutUseCase _signOutUseCase;

  LoginBloc(
    this._loginStreamUseCase,
    this._signInWithEmailAndPasswordUseCase,
    this._signOutUseCase,
  ) : super(LoginInitial()) {
    on<StartWatchingUser>(_onWatchUserSubscription);
    on<SignInWithEmailAndPasswordRequested>(
        _onSignInWithEmailAndPasswordRequested);
    on<SignOutRequested>(_onSignOutRequested);

    add(StartWatchingUser());
  }

  Future<void> _onWatchUserSubscription(
    StartWatchingUser event,
    Emitter<LoginState> emit,
  ) async {
    await emit.forEach(_loginStreamUseCase.call(NoParams()), onData: (user) {
      if (user != null) {
        return LoggedIn(user: user);
      } else {
        return const NotLoggedIn();
      }
    });
  }

  Future<void> _onSignInWithEmailAndPasswordRequested(
    SignInWithEmailAndPasswordRequested event,
    Emitter<LoginState> emit,
  ) async {
    final fieldsErrors = [
      if (!event.email.isValidEmail) LoginFieldError.emailNotValid,
      if (event.email.isEmpty) LoginFieldError.emailRequired,
      if (!event.password.isStrongPassword) LoginFieldError.passwordNotValid,
      if (event.password.isEmpty) LoginFieldError.passwordRequired,
    ];

    if (fieldsErrors.isNotEmpty) {
      emit(
        NotLoggedIn(
          errors: fieldsErrors,
        ),
      );
    } else {
      emit(const LoginLoading());
      final dataState = await _signInWithEmailAndPasswordUseCase(
        SignInWithEmailAndPasswordParams(
          email: event.email,
          password: event.password,
        ),
      );

      if (dataState is DataSuccess && dataState.data != null) {
        emit(
          LoggedIn(
            user: dataState.data!,
          ),
        );
      } else if (dataState is DataFailed) {
        // TODO: Add emailAlreadyInUse case
        emit(
          LoginError(
            message: dataState.error?.toString() ?? 'Unknown Errorf',
          ),
        );
      }
    }
  }

  Future<void> _onSignOutRequested(
      SignOutRequested event, Emitter<LoginState> emit) async {
    final dataState = await _signOutUseCase(NoParams());

    if (dataState is DataSuccess) {
      emit(const NotLoggedIn());
    } else if (dataState is DataFailed) {
      _emitError(dataState, emit);
    }
  }

  void _emitError(DataFailed failure, Emitter<LoginState> emit) async => emit(
        LoginError(
          message: failure.error?.toString() ?? 'Unknown Error',
        ),
      );
}
