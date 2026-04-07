import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/errors/local_database_exception.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_status.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/saved_articles/saved_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/articles_list.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

class MockLocalArticleBloc
    extends MockBloc<LocalArticlesEvent, LocalArticlesState>
    implements LocalArticleBloc {}

void main() {
  late MockLocalArticleBloc mockLocalArticleBloc;

  setUp(() async {
    mockLocalArticleBloc = MockLocalArticleBloc();
    await sl.reset();
    sl.registerFactory<LocalArticleBloc>(() => mockLocalArticleBloc);
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: SavedArticles(),
    );
  }

  group('SavedArticles Widget Tests', () {
    testWidgets(
        'Should display CupertinoActivityIndicator when state is Loading',
        (tester) async {
      when(() => mockLocalArticleBloc.state)
          .thenReturn(const LocalArticlesLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
    });

    testWidgets('Should display "NO SAVED ARTICLES" when state is Empty',
        (tester) async {
      when(() => mockLocalArticleBloc.state)
          .thenReturn(const LocalArticleEmpty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('NO SAVED ARTICLES'), findsOneWidget);
    });

    testWidgets('Should display "ERROR" when state is Error', (tester) async {
      when(() => mockLocalArticleBloc.state).thenReturn(
        const LocalArticlesError(
          LocalDatabaseClosedException(message: 'test'),
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('ERROR'), findsOneWidget);
    });

    testWidgets('Should display ArticlesList when state is Done with articles',
        (tester) async {
      when(() => mockLocalArticleBloc.state).thenReturn(const LocalArticlesDone(
          articles: [], status: LocalArticleStatus.none));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(ArticlesList), findsOneWidget);
    });

    testWidgets('Should show SnackBar when status changes to deletedSuccess',
        (tester) async {
      whenListen(
        mockLocalArticleBloc,
        Stream.fromIterable([
          const LocalArticlesDone(
              articles: [], status: LocalArticleStatus.none),
          const LocalArticlesDone(
              articles: [], status: LocalArticleStatus.deletedSuccess),
        ]),
        initialState: const LocalArticlesDone(
            articles: [], status: LocalArticleStatus.none),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Rebuild so the SnackBar appears
      await tester.pump();

      expect(find.text('DELETED ARTICLE'), findsOneWidget);
    });
  });
}
