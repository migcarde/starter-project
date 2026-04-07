import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/article_detail/article_detail.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/base_network_image.dart';
import 'package:news_app_clean_architecture/injection_container.dart';
import 'package:ionicons/ionicons.dart';

// Create Mock Bloc
class MockLocalArticleBloc
    extends MockBloc<LocalArticlesEvent, LocalArticlesState>
    implements LocalArticleBloc {}

class FakeLocalArticleEvent extends Fake implements LocalArticlesEvent {}

void main() {
  late MockLocalArticleBloc mockLocalArticleBloc;

  // Test Article
  const testArticle = ArticleEntity(
    title: 'Test Title',
    publishedAt: '2023-10-27',
    urlToImage: 'https://test.com/image.png',
    description: 'Test Description',
    content: 'Test Content',
  );

  setUpAll(() {
    registerFallbackValue(FakeLocalArticleEvent());
  });

  setUp(() async {
    mockLocalArticleBloc = MockLocalArticleBloc();
    await sl.reset();
    sl.registerFactory<LocalArticleBloc>(() => mockLocalArticleBloc);
    when(() => mockLocalArticleBloc.state)
        .thenReturn(const LocalArticlesLoading());
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: ArticleDetailsView(article: testArticle),
    );
  }

  group('ArticleDetailsView Widget Tests', () {
    testWidgets(
        'Should render the article details correctly (Title, Date, Content)',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text(testArticle.title!), findsOneWidget);
      expect(find.text(testArticle.publishedAt!), findsOneWidget);
      expect(find.text(testArticle.description!), findsOneWidget);
      expect(find.byType(BaseNetworkImage), findsOneWidget);
    });

    testWidgets('Should show the FloatingActionButton with bookmark icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Ionicons.bookmark), findsOneWidget);
    });

    testWidgets(
        'Should trigger the SaveArticle event and show SnackBar when button is pressed',
        (WidgetTester tester) async {
      // Stub so it does nothing when receiving the event
      when(() => mockLocalArticleBloc.add(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(FloatingActionButton));

      // Rebuild so the SnackBar appears
      await tester.pump();

      verify(() => mockLocalArticleBloc.add(const SaveArticle(testArticle)))
          .called(1);
      expect(find.text('Article saved successfully.'), findsOneWidget);
    });

    testWidgets('Should not render the description if it is null',
        (WidgetTester tester) async {
      const articleNoDesc = ArticleEntity(
        title: 'No Desc',
        urlToImage: '',
        description: '',
        content: 'Content',
      );

      await tester.pumpWidget(
          const MaterialApp(home: ArticleDetailsView(article: articleNoDesc)));

      expect(find.text('Test Description'), findsNothing);
    });
  });
}
