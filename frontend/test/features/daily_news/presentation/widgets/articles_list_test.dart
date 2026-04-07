import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_tile.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/articles_list.dart';

class DummyArticle extends ArticleEntity {
  const DummyArticle({
    int? id,
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

class MockNavigatorObserver extends NavigatorObserver {
  String? pushedRouteName;
  Object? pushedArguments;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      pushedRouteName = route.settings.name;
      pushedArguments = route.settings.arguments;
    }
  }
}

void main() {
  group('ArticlesList', () {
    final List<ArticleEntity> mockArticles = [
      const DummyArticle(
          id: 1, title: 'Article 1', urlToImage: 'url1', publishedAt: 'time1'),
      const DummyArticle(
          id: 2, title: 'Article 2', urlToImage: 'url2', publishedAt: 'time2'),
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
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/ArticleDetails': (context) =>
                const Scaffold(body: Text('Details Page')),
          },
          home: Scaffold(
            body: ArticlesList(
              articles: mockArticles,
            ),
          ),
        ),
      );

      final articleWidgets = find.byType(ArticleWidget);
      await tester.tap(articleWidgets.first);
      await tester.pumpAndSettle();

      expect(mockObserver.pushedRouteName, '/ArticleDetails');
      expect(mockObserver.pushedArguments, mockArticles.first);
      expect(find.text('Details Page'), findsOneWidget);
    });
  });
}
