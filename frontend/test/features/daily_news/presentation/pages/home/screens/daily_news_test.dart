import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/config/routes/paths.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/core/errors/network_exception.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_status.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/home/daily_news.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_bloc.dart';
import 'package:news_app_clean_architecture/features/login/domain/entities/user.dart';
import 'package:go_router/go_router.dart';

class MockRemoteArticlesBloc
    extends MockBloc<RemoteArticlesEvent, RemoteArticlesState>
    implements RemoteArticlesBloc {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockLocalArticleBloc
    extends MockBloc<LocalArticlesEvent, LocalArticlesState>
    implements LocalArticleBloc {}

class MockUserEntity extends Mock implements UserEntity {}

void main() {
  late MockRemoteArticlesBloc mockBloc;
  late MockLoginBloc mockLoginBloc;
  late MockLocalArticleBloc mockLocalBloc;
  late GetIt getIt;

  setUp(() {
    mockBloc = MockRemoteArticlesBloc();
    mockLoginBloc = MockLoginBloc();
    mockLocalBloc = MockLocalArticleBloc();
    getIt = GetIt.instance;
    if (getIt.isRegistered<RemoteArticlesBloc>()) {
      getIt.unregister<RemoteArticlesBloc>();
    }
    getIt.registerSingleton<RemoteArticlesBloc>(mockBloc);
    if (getIt.isRegistered<LocalArticleBloc>()) {
      getIt.unregister<LocalArticleBloc>();
    }
    getIt.registerSingleton<LocalArticleBloc>(mockLocalBloc);
    when(() => mockLocalBloc.state).thenReturn(const LocalArticlesLoading());
  });

  tearDown(() {
    if (getIt.isRegistered<RemoteArticlesBloc>()) {
      getIt.unregister<RemoteArticlesBloc>();
    }
    if (getIt.isRegistered<LocalArticleBloc>()) {
      getIt.unregister<LocalArticleBloc>();
    }
  });

  makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>.value(value: mockLoginBloc),
      ],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: Paths.dailyNews.path,
          routes: AppRoutes.list,
        ),
      ),
    );
  }

  group('Daily News Widget Tests', () {
    testWidgets(
        'Should display loading indicator when state is RemoteArticlesLoading',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(const RemoteArticlesLoading());

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('Should display ArticlesList when state is RemoteArticlesDone',
        (WidgetTester tester) async {
      when(() => mockBloc.state)
          .thenReturn(const RemoteArticlesDone(articles: []));

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets(
        'Should display no articles found when state is RemoteArticleEmpty',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(const RemoteArticleEmpty());

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      expect(find.text('No articles found'), findsOneWidget);
    });

    testWidgets('Should display refresh icon when state is RemoteArticlesError',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        const RemoteArticlesError(
          NetworkNotFoundException(),
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('Should trigger GetArticles event on pull-to-refresh',
        (WidgetTester tester) async {
      when(() => mockBloc.state)
          .thenReturn(const RemoteArticlesDone(articles: []));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(const RemoteArticlesDone(articles: [])),
      );

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      verify(() => mockBloc.add(const GetArticles())).called(greaterThan(0));
    });

    testWidgets('Go to SavedArticles when bookmark icon is pressed',
        (WidgetTester tester) async {
      when(() => mockBloc.state)
          .thenReturn(const RemoteArticlesDone(articles: []));
      when(() => mockLocalBloc.state)
          .thenReturn(const LocalArticlesDone(articles: []));

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      final bookmarkIcon = find.byIcon(Icons.bookmark);
      expect(bookmarkIcon, findsOneWidget);
      await tester.tap(bookmarkIcon);

      await tester.pumpAndSettle();

      expect(find.text('Saved Articles'), findsOneWidget);
    });

    testWidgets('Should show floating action button',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(const RemoteArticlesLoading());

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets(
        'Should open modal bottom sheet when floating button is tapped and user is logged in',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(const RemoteArticlesLoading());
      when(() => mockLoginBloc.state)
          .thenReturn(LoggedIn(user: MockUserEntity()));

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.text('Write your title here...'), findsOneWidget);
    });

    testWidgets(
        'Should close modal and show success snackbar when publish succeeds',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final streamController =
          StreamController<RemoteArticlesState>.broadcast();
      when(() => mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(() => mockBloc.state).thenReturn(const RemoteArticlesLoading());
      when(() => mockLoginBloc.state)
          .thenReturn(LoggedIn(user: MockUserEntity()));

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      streamController.add(const RemoteArticlesDone(
          articles: [], status: RemoteArticleStatus.createdArticleSuccess));
      await tester.pump();

      expect(find.text('PUBLISHED ARTICLE'), findsOneWidget);
      expect(find.text('Write your title here...'), findsNothing);

      await streamController.close();
    });

    testWidgets('Should show error snackbar when publish fails',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final streamController =
          StreamController<RemoteArticlesState>.broadcast();
      when(() => mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(() => mockBloc.state).thenReturn(const RemoteArticlesLoading());
      when(() => mockLoginBloc.state)
          .thenReturn(LoggedIn(user: MockUserEntity()));

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      streamController.add(const RemoteArticlesDone(
          articles: [], status: RemoteArticleStatus.genericError));
      await tester.pump();

      expect(find.text('GENERIC ERROR'), findsOneWidget);
      expect(find.text('Write your title here...'), findsNothing);

      await streamController.close();
    });
  });
}
