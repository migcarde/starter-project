import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class GetArticlesUseCase
    implements UseCase<DataState<List<ArticleEntity>>, NoParams> {
  final ArticleRepository _articleRepository;

  GetArticlesUseCase(this._articleRepository);

  @override
  Future<DataState<List<ArticleEntity>>> call(NoParams params) async {
    // TODO: Replace with repository call
    return const DataSuccess(
      [
        ArticleEntity(
            id: 1,
            author: "John Doe",
            title: "Exploring the Future of Flutter",
            description:
                "A deep dive into the next big features coming to Flutter.",
            url: "https://example.com/flutter-future",
            urlToImage:
                "https://images.unsplash.com/photo-1551288049-bbda4865cda0",
            publishedAt: "2024-05-20T10:00:00Z",
            content: "Content about Flutter future..."),
        ArticleEntity(
            id: 2,
            author: "Jane Smith",
            title: "The Rise of AI in Mobile Apps",
            description:
                "How artificial intelligence is transforming the mobile landscape.",
            url: "https://example.com/ai-mobile",
            urlToImage:
                "https://images.unsplash.com/photo-1507146153580-69a1ff6d1403",
            publishedAt: "2024-05-21T12:30:00Z",
            content: "Content about AI in mobile..."),
        ArticleEntity(
            id: 3,
            author: "Alice Johnson",
            title: "Clean Architecture in Dart",
            description:
                "Best practices for structuring your Dart and Flutter projects.",
            url: "https://example.com/clean-arch",
            urlToImage:
                "https://images.unsplash.com/photo-1498050108023-c5249f4df085",
            publishedAt: "2024-05-22T09:15:00Z",
            content: "Content about Clean Architecture..."),
        ArticleEntity(
            id: 4,
            author: "Bob Brown",
            title: "State Management Showdown",
            description:
                "Comparing Provider, Riverpod, and Bloc for your next project.",
            url: "https://example.com/state-mgmt",
            urlToImage:
                "https://images.unsplash.com/photo-1542831371-29b0f74f9713",
            publishedAt: "2024-05-23T14:45:00Z",
            content: "Content about state management..."),
        ArticleEntity(
            id: 5,
            author: "Charlie Davis",
            title: "Mastering Flutter Animations",
            description:
                "Create stunning user experiences with advanced Flutter animations.",
            url: "https://example.com/flutter-animations",
            urlToImage:
                "https://images.unsplash.com/photo-1460925895917-afdab827c52f",
            publishedAt: "2024-05-24T11:20:00Z",
            content: "Content about animations..."),
        ArticleEntity(
            id: 6,
            author: "Diana Prince",
            title: "Securing Your Flutter App",
            description:
                "Essential security tips for protecting user data in mobile apps.",
            url: "https://example.com/flutter-security",
            urlToImage:
                "https://images.unsplash.com/photo-1510511459019-5deeel7148a",
            publishedAt: "2024-05-25T16:00:00Z",
            content: "Content about security..."),
        ArticleEntity(
            id: 7,
            author: "Ethan Hunt",
            title: "Testing Flutter Applications",
            description:
                "Unit, widget, and integration testing for robust Flutter apps.",
            url: "https://example.com/flutter-testing",
            urlToImage:
                "https://images.unsplash.com/photo-1517694712202-14dd9538aa97",
            publishedAt: "2024-05-26T08:30:00Z",
            content: "Content about testing..."),
        ArticleEntity(
            id: 8,
            author: "Fiona Gallagher",
            title: "Flutter Performance Optimization",
            description:
                "Identify and fix performance bottlenecks in your applications.",
            url: "https://example.com/flutter-performance",
            urlToImage:
                "https://images.unsplash.com/photo-1454165833267-3d7f1fbc5a2c",
            publishedAt: "2024-05-27T13:10:00Z",
            content: "Content about performance..."),
        ArticleEntity(
            id: 9,
            author: "George Miller",
            title: "Responsive UI with Flutter",
            description:
                "Building apps that look great on any screen size or platform.",
            url: "https://example.com/flutter-responsive",
            urlToImage:
                "https://images.unsplash.com/photo-1555066931-4365d14bab8c",
            publishedAt: "2024-05-28T10:50:00Z",
            content: "Content about responsive UI..."),
        ArticleEntity(
            id: 10,
            author: "Hannah Abbott",
            title: "Dart 3.0: What's New?",
            description:
                "Exploring patterns, records, and class modifiers in Dart 3.0.",
            url: "https://example.com/dart-3",
            urlToImage:
                "https://images.unsplash.com/photo-1484417894907-623942c8ee29",
            publishedAt: "2024-05-29T15:00:00Z",
            content: "Content about Dart 3.0...")
      ],
    );
    //return _articleRepository.getNewsArticles();
  }
}
