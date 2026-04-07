import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/login/domain/entities/user.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_bloc.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_field_error.dart';
import 'package:news_app_clean_architecture/features/login/presentation/pages/login/login.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  late MockLoginBloc mockLoginBloc;
  late GetIt getIt;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    getIt = GetIt.instance;
    if (getIt.isRegistered<LoginBloc>()) {
      getIt.unregister<LoginBloc>();
    }
    getIt.registerSingleton<LoginBloc>(mockLoginBloc);

    when(() => mockLoginBloc.state).thenReturn(LoginInitial());
    when(() => mockLoginBloc.stream)
        .thenAnswer((_) => Stream<LoginState>.value(LoginInitial()));
  });

  tearDown(() {
    if (getIt.isRegistered<LoginBloc>()) {
      getIt.unregister<LoginBloc>();
    }
  });

  Widget makeTestableWidget() {
    return const MaterialApp(home: LoginView());
  }

  Finder hintField(String hint) {
    return find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.hintText == hint,
      description: 'TextField with hint "$hint"',
    );
  }

  testWidgets('renders email and password fields and login button',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    expect(hintField('email'), findsOneWidget);
    expect(hintField('password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('adds SignInWithEmailAndPasswordRequested when login tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(hintField('email'), 'test@test.com');
    await tester.enterText(hintField('password'), 'SuperSecret123!');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    verify(() => mockLoginBloc.add(
          SignInWithEmailAndPasswordRequested(
            email: 'test@test.com',
            password: 'SuperSecret123!',
          ),
        )).called(1);
  });

  testWidgets('renders login form in NotLoggedIn state',
      (WidgetTester tester) async {
    when(() => mockLoginBloc.state).thenReturn(
      const NotLoggedIn(),
    );
    when(() => mockLoginBloc.stream)
        .thenAnswer((_) => Stream<LoginState>.value(const NotLoggedIn()));

    await tester.pumpWidget(makeTestableWidget());

    expect(hintField('email'), findsOneWidget);
    expect(hintField('password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('renders login form in LoggedIn state',
      (WidgetTester tester) async {
    when(() => mockLoginBloc.state).thenReturn(
      const LoggedIn(user: UserEntity(id: '1', email: 'test@test.com')),
    );
    when(() => mockLoginBloc.stream).thenAnswer(
      (_) => Stream<LoginState>.value(
        const LoggedIn(user: UserEntity(id: '1', email: 'test@test.com')),
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(hintField('email'), findsOneWidget);
    expect(hintField('password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('shows validation error text for email and password fields',
      (WidgetTester tester) async {
    when(() => mockLoginBloc.state).thenReturn(
      const NotLoggedIn(
        errors: [
          LoginFieldError.emailRequired,
          LoginFieldError.passwordRequired,
        ],
      ),
    );
    when(() => mockLoginBloc.stream).thenAnswer(
      (_) => Stream<LoginState>.value(
        const NotLoggedIn(
          errors: [
            LoginFieldError.emailRequired,
            LoginFieldError.passwordRequired,
          ],
        ),
      ),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('shows loading indicator when state is LoginLoading',
      (WidgetTester tester) async {
    when(() => mockLoginBloc.state).thenReturn(const LoginLoading());
    when(() => mockLoginBloc.stream)
        .thenAnswer((_) => Stream<LoginState>.value(const LoginLoading()));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows login error message when state is LoginError',
      (WidgetTester tester) async {
    when(() => mockLoginBloc.state)
        .thenReturn(const LoginError(message: 'Something broke'));
    when(() => mockLoginBloc.stream).thenAnswer(
      (_) => Stream<LoginState>.value(LoginError(message: 'Something broke')),
    );

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Something was wrong'), findsOneWidget);
  });
}
