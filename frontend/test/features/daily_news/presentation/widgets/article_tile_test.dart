import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_tile.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/base_network_image.dart';

// Create a dummy ArticleEntity for testing
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

void main() {
  group('ArticleWidget', () {
    const testArticle = DummyArticle(
      id: 1,
      title: 'Test Title',
      description: 'Test Description',
      urlToImage: 'https://example.com/image.jpg',
      publishedAt: '2023-10-10',
    );

    testWidgets('renders all details correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticleWidget(
              article: testArticle,
              isRemovable: false,
              onRemove: (article) {},
              onArticlePressed: (article) {},
            ),
          ),
        ),
      );

      // Verify title is rendered
      expect(find.text('Test Title'), findsOneWidget);

      // Verify description is rendered
      expect(find.text('Test Description'), findsOneWidget);

      // Verify date is rendered
      expect(find.text('2023-10-10'), findsOneWidget);

      // Verify image wrapper is rendered
      expect(find.byType(BaseNetworkImage), findsOneWidget);

      // Because isRemovable is false, close icon shouldn't be rendered
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('calls onArticlePressed when tapped', (WidgetTester tester) async {
      bool pressed = false;
      ArticleEntity? pressedArticle;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticleWidget(
              article: testArticle,
              isRemovable: false,
              onRemove: (article) {},
              onArticlePressed: (article) {
                pressed = true;
                pressedArticle = article;
              },
            ),
          ),
        ),
      );

      // Tap on the widget itself (GestureDetector wrapping the entire tile)
      await tester.tap(find.byType(ArticleWidget));
      await tester.pump();

      expect(pressed, isTrue);
      expect(pressedArticle, testArticle);
    });

    testWidgets('shows remove button and calls onRemove when isRemovable is true', (WidgetTester tester) async {
      bool removed = false;
      ArticleEntity? removedArticle;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticleWidget(
              article: testArticle,
              isRemovable: true,
              onRemove: (article) {
                removed = true;
                removedArticle = article;
              },
              onArticlePressed: (article) {},
            ),
          ),
        ),
      );

      // Verify close icon is rendered when isRemovable is true
      final closeIconFinder = find.byIcon(Icons.close);
      expect(closeIconFinder, findsOneWidget);

      // Tap on the close icon
      await tester.tap(closeIconFinder);
      await tester.pump();

      expect(removed, isTrue);
      expect(removedArticle, testArticle);
    });
  });
}
