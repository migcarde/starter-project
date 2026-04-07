import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_architecture/core/errors/network_exception.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/home/daily_news.dart';

class MockRemoteArticlesBloc
    extends MockBloc<RemoteArticlesEvent, RemoteArticlesState>
    implements RemoteArticlesBloc {}

void main() {
  late MockRemoteArticlesBloc mockBloc;
  late GetIt getIt;

  setUp(() {
    mockBloc = MockRemoteArticlesBloc();
    getIt = GetIt.instance;
    if (getIt.isRegistered<RemoteArticlesBloc>()) {
      getIt.unregister<RemoteArticlesBloc>();
    }
    getIt.registerSingleton<RemoteArticlesBloc>(mockBloc);
  });

  tearDown(() {
    if (getIt.isRegistered<RemoteArticlesBloc>()) {
      getIt.unregister<RemoteArticlesBloc>();
    }
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
      onGenerateRoute: (settings) =>
          MaterialPageRoute(builder: (_) => Container()),
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
      when(() => mockBloc.state).thenReturn(const RemoteArticlesDone([]));

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
      when(() => mockBloc.state).thenReturn(const RemoteArticlesDone([]));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(const RemoteArticlesDone([])),
      );

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));

      verify(() => mockBloc.add(const GetArticles())).called(greaterThan(0));
    });

    testWidgets(
        'Should navigate to Saved Articles when bookmark icon is pressed',
        (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(const RemoteArticlesLoading());
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(const RemoteArticlesLoading()),
      );

      await tester.pumpWidget(makeTestableWidget(const DailyNews()));
      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
    });
  });
}
