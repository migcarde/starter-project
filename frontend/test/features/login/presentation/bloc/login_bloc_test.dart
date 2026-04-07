import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/login/domain/entities/sign_in_with_email_and_password_params.dart';
import 'package:news_app_clean_architecture/features/login/domain/entities/user.dart';
import 'package:news_app_clean_architecture/features/login/domain/usecases/login_stream.dart';
import 'package:news_app_clean_architecture/features/login/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:news_app_clean_architecture/features/login/domain/usecases/sign_out.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_bloc.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_field_error.dart';

class MockLoginStreamUseCase extends Mock implements LoginStreamUseCase {}

class MockSignInWithEmailAndPasswordUseCase extends Mock
    implements SignInWithEmailAndPasswordUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginStreamUseCase mockLoginStreamUseCase;
  late MockSignInWithEmailAndPasswordUseCase
      mockSignInWithEmailAndPasswordUseCase;
  late MockSignOutUseCase mockSignOutUseCase;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const SignInWithEmailAndPasswordParams(
      email: 'test@test.com',
      password: 'test',
    ));
  });

  setUp(() {
    mockLoginStreamUseCase = MockLoginStreamUseCase();
    mockSignInWithEmailAndPasswordUseCase =
        MockSignInWithEmailAndPasswordUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc Tests', () {
    group('StartWatchingUser', () {
      blocTest<LoginBloc, LoginState>(
        'Should emit LoggedIn when user stream returns a user',
        build: () {
          const mockUser = UserEntity(id: '1', email: 'test@test.com');

          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(mockUser));

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        expect: () => [
          const LoggedIn(
            user: UserEntity(id: '1', email: 'test@test.com'),
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'Should emit NotLoggedIn when user stream returns null',
        build: () {
          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(null));

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        expect: () => [
          const NotLoggedIn(),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'Should emit NotLoggedIn initially and then LoggedIn when user logs in',
        build: () {
          const mockUser = UserEntity(id: '1', email: 'test@test.com');

          when(() => mockLoginStreamUseCase.call(any())).thenAnswer(
            (_) => Stream.fromIterable([null, mockUser]),
          );

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        expect: () => [
          const NotLoggedIn(),
          const LoggedIn(
            user: UserEntity(id: '1', email: 'test@test.com'),
          ),
        ],
      );
    });

    group('SignInWithEmailAndPasswordRequested', () {
      blocTest<LoginBloc, LoginState>(
        'Should emit NotLoggedIn with emailRequired error when email is empty',
        build: () {
          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(null));

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        act: (bloc) => bloc.add(
          SignInWithEmailAndPasswordRequested(
            email: '',
            password: 'ValidPassword123!',
          ),
        ),
        expect: () => [
          const NotLoggedIn(),
          isA<NotLoggedIn>().having(
            (state) => state.errors.contains(LoginFieldError.emailRequired),
            'contains emailRequired',
            true,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'Should emit NotLoggedIn with passwordRequired error when password is empty',
        build: () {
          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(null));

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        act: (bloc) => bloc.add(
          SignInWithEmailAndPasswordRequested(
            email: 'test@test.com',
            password: '',
          ),
        ),
        expect: () => [
          const NotLoggedIn(),
          isA<NotLoggedIn>().having(
            (state) => state.errors.contains(LoginFieldError.passwordRequired),
            'contains passwordRequired',
            true,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'Should emit NotLoggedIn with emailNotValid error when email format is invalid',
        build: () {
          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(null));

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        act: (bloc) => bloc.add(
          SignInWithEmailAndPasswordRequested(
            email: 'invalidemail',
            password: 'ValidPassword123!',
          ),
        ),
        expect: () => [
          const NotLoggedIn(),
          const NotLoggedIn(
            errors: [LoginFieldError.emailNotValid],
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'Should emit NotLoggedIn with passwordNotValid error when password is weak',
        build: () {
          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(null));

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        act: (bloc) => bloc.add(
          SignInWithEmailAndPasswordRequested(
            email: 'test@test.com',
            password: 'weak',
          ),
        ),
        expect: () => [
          const NotLoggedIn(),
          const NotLoggedIn(
            errors: [LoginFieldError.passwordNotValid],
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'Should emit multiple errors when both email and password are invalid',
        build: () {
          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(null));

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        act: (bloc) => bloc.add(
          SignInWithEmailAndPasswordRequested(
            email: '',
            password: '',
          ),
        ),
        verify: (bloc) {
          final lastState = bloc.state;
          if (lastState is NotLoggedIn) {
            expect(lastState.errors.length, 4);
            expect(
              lastState.errors.contains(LoginFieldError.emailRequired),
              true,
            );
            expect(
              lastState.errors.contains(LoginFieldError.passwordRequired),
              true,
            );
          }
        },
      );

      blocTest<LoginBloc, LoginState>(
        'Should emit LoginLoading then LoggedIn when sign in is successful',
        build: () {
          const mockUser = UserEntity(id: '1', email: 'test@test.com');

          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(null));

          when(() => mockSignInWithEmailAndPasswordUseCase(any()))
              .thenAnswer((_) async => const DataSuccess(mockUser));

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        act: (bloc) => bloc.add(
          SignInWithEmailAndPasswordRequested(
            email: 'test@test.com',
            password: 'ValidPassword123!',
          ),
        ),
        expect: () => [
          const NotLoggedIn(),
          const LoginLoading(),
          const LoggedIn(
            user: UserEntity(id: '1', email: 'test@test.com'),
          ),
        ],
        verify: (bloc) {
          verify(
            () => mockSignInWithEmailAndPasswordUseCase(any()),
          ).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'Should emit LoginLoading then LoginError when sign in fails',
        build: () {
          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(null));

          when(() => mockSignInWithEmailAndPasswordUseCase(any())).thenAnswer(
            (_) async => DataFailed(Exception('Wrong password')),
          );

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        act: (bloc) => bloc.add(
          SignInWithEmailAndPasswordRequested(
            email: 'test@test.com',
            password: 'ValidPassword123!',
          ),
        ),
        expect: () => [
          const NotLoggedIn(),
          const LoginLoading(),
          isA<LoginError>(),
        ],
      );
    });

    group('SignOutRequested', () {
      blocTest<LoginBloc, LoginState>(
        'Should emit NotLoggedIn when sign out is successful',
        build: () {
          const mockUser = UserEntity(id: '1', email: 'test@test.com');

          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(mockUser));

          when(() => mockSignOutUseCase(any()))
              .thenAnswer((_) async => const DataSuccess(null));

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        act: (bloc) => bloc.add(SignOutRequested()),
        expect: () => [
          const LoggedIn(
            user: UserEntity(id: '1', email: 'test@test.com'),
          ),
          const NotLoggedIn(),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'Should emit LoginError when sign out fails',
        build: () {
          const mockUser = UserEntity(id: '1', email: 'test@test.com');

          when(() => mockLoginStreamUseCase.call(any()))
              .thenAnswer((_) => Stream.value(mockUser));

          when(() => mockSignOutUseCase(any())).thenAnswer(
            (_) async => DataFailed(Exception('Failed to sign out')),
          );

          loginBloc = LoginBloc(
            mockLoginStreamUseCase,
            mockSignInWithEmailAndPasswordUseCase,
            mockSignOutUseCase,
          );
          return loginBloc;
        },
        act: (bloc) => bloc.add(SignOutRequested()),
        expect: () => [
          const LoggedIn(
            user: UserEntity(id: '1', email: 'test@test.com'),
          ),
          isA<LoginError>(),
        ],
      );
    });
  });
}
