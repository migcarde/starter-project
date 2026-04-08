import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/config/routes/paths.dart';
import 'package:news_app_clean_architecture/config/routes/routes.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_tile.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/articles_list.dart';

class MockRemoteArticlesBloc
    extends MockBloc<RemoteArticlesEvent, RemoteArticlesState>
    implements RemoteArticlesBloc {}

class MockLocalArticlesBloc
    extends MockBloc<LocalArticlesEvent, LocalArticlesState>
    implements LocalArticleBloc {}

class DummyArticle extends ArticleEntity {
  const DummyArticle({
    String? id,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
  }) : super(
          id: id,
          author: author,
          title: title,
          description: description,
          url: url,
          urlToImage: urlToImage,
          publishedAt: publishedAt,
          content: content,
        );
}

void main() {
  late MockRemoteArticlesBloc mockRemoteArticlesBloc;
  late MockLocalArticlesBloc mockLocalArticlesBloc;
  late GetIt getIt;

  setUp(() {
    mockRemoteArticlesBloc = MockRemoteArticlesBloc();
    mockLocalArticlesBloc = MockLocalArticlesBloc();
    getIt = GetIt.instance;
    if (getIt.isRegistered<RemoteArticlesBloc>()) {
      getIt.unregister<RemoteArticlesBloc>();
    }
    if (getIt.isRegistered<LocalArticleBloc>()) {
      getIt.unregister<LocalArticleBloc>();
    }
    getIt.registerSingleton<RemoteArticlesBloc>(mockRemoteArticlesBloc);
    getIt.registerSingleton<LocalArticleBloc>(mockLocalArticlesBloc);
  });

  tearDown(() {
    if (getIt.isRegistered<RemoteArticlesBloc>()) {
      getIt.unregister<RemoteArticlesBloc>();
    }
    if (getIt.isRegistered<LocalArticleBloc>()) {
      getIt.unregister<LocalArticleBloc>();
    }
  });

  group('ArticlesList', () {
    final List<ArticleEntity> mockArticles = [
      const DummyArticle(
          id: '1',
          title: 'Article 1',
          urlToImage: 'url1',
          publishedAt: 'time1'),
      const DummyArticle(
          id: '2',
          title: 'Article 2',
          urlToImage: 'url2',
          publishedAt: 'time2'),
    ];

    testWidgets('renders correct number of ArticleWidgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticlesList(
              articles: mockArticles,
            ),
          ),
        ),
      );

      expect(find.byType(ArticleWidget), findsNWidgets(2));
    });

    testWidgets('handles onRemove correctly when isRemovable is true',
        (WidgetTester tester) async {
      bool removeCalled = false;
      ArticleEntity? removedArticle;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticlesList(
              articles: mockArticles,
              isRemovable: true,
              onRemove: (article) {
                removeCalled = true;
                removedArticle = article;
              },
            ),
          ),
        ),
      );

      final closeIcons = find.byIcon(Icons.close);
      expect(closeIcons, findsNWidgets(2));

      await tester.tap(closeIcons.first);
      await tester.pump();

      expect(removeCalled, isTrue);
      expect(removedArticle, mockArticles.first);
    });

    testWidgets('does not show close icons if isRemovable is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticlesList(
              articles: mockArticles,
              isRemovable: false,
            ),
          ),
        ),
      );

      expect(find.byType(ArticleWidget), findsNWidgets(2));
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('navigates to ArticleDetails when an article is pressed',
        (WidgetTester tester) async {
      const dummyArticle = DummyArticle(
        id: '1',
        title: 'Article 1',
        urlToImage: 'url1',
        publishedAt: 'time1',
      );

      when(() => mockRemoteArticlesBloc.state)
          .thenReturn(const RemoteArticlesDone(articles: [dummyArticle]));

      when(() => mockLocalArticlesBloc.state)
          .thenReturn(const LocalArticleEmpty());

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<RemoteArticlesBloc>.value(
                value: mockRemoteArticlesBloc),
            BlocProvider<LocalArticleBloc>.value(value: mockLocalArticlesBloc),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: Paths.dailyNews.path,
              routes: AppRoutes.list,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Article 1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byIcon(Ionicons.bookmark), findsOneWidget);
    });
  });
}
