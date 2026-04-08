import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/errors/network_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class MockGetArticleUseCase extends Mock implements GetArticlesUseCase {}

class MockSaveArticleUseCase extends Mock implements SaveArticleUseCase {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockGetArticleUseCase mockGetArticleUseCase;
  late MockSaveArticleUseCase mockSaveArticleUseCase;
  late RemoteArticlesBloc remoteArticlesBloc;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetArticleUseCase = MockGetArticleUseCase();
    mockSaveArticleUseCase = MockSaveArticleUseCase();
    remoteArticlesBloc = RemoteArticlesBloc(
      mockGetArticleUseCase,
      mockSaveArticleUseCase,
    );
  });

  tearDown(() {
    remoteArticlesBloc.close();
  });

  const article = ArticleEntity(
    id: '1',
    author: 'John Doe',
    title: 'Test Title',
    description: 'Test Description',
    url: 'http://test.com',
    urlToImage: 'http://image.com',
    publishedAt: '2024-01-01',
    content: 'Test content',
  );

  const articlesList = [article];

  group('RemoteArticlesBloc', () {
    test('initial state should be RemoteArticlesLoading', () {
      expect(remoteArticlesBloc.state, const RemoteArticlesLoading());
    });

    blocTest<RemoteArticlesBloc, RemoteArticlesState>(
      'emits [RemoteArticlesLoading, RemoteArticlesDone] when GetArticles is added and usecase returns DataSuccess with articles',
      build: () {
        when(() => mockGetArticleUseCase.call(any()))
            .thenAnswer((_) async => const DataSuccess(articlesList));
        return remoteArticlesBloc;
      },
      act: (bloc) => bloc.add(const GetArticles()),
      expect: () => [
        const RemoteArticlesLoading(),
        const RemoteArticlesDone(articles: articlesList),
      ],
      verify: (bloc) {
        verify(() => mockGetArticleUseCase.call(any())).called(1);
      },
    );

    blocTest<RemoteArticlesBloc, RemoteArticlesState>(
      'emits [RemoteArticlesLoading, RemoteArticleEmpty] when GetArticles is added and usecase returns DataSuccess with empty list',
      build: () {
        when(() => mockGetArticleUseCase.call(any()))
            .thenAnswer((_) async => const DataSuccess([]));
        return remoteArticlesBloc;
      },
      act: (bloc) => bloc.add(const GetArticles()),
      expect: () => [
        const RemoteArticlesLoading(),
        const RemoteArticleEmpty(),
      ],
      verify: (bloc) {
        verify(() => mockGetArticleUseCase.call(any())).called(1);
      },
    );

    blocTest<RemoteArticlesBloc, RemoteArticlesState>(
      'emits [RemoteArticlesLoading, RemoteArticlesError] when GetArticles is added and usecase returns DataFailed',
      build: () {
        when(() => mockGetArticleUseCase.call(any())).thenAnswer(
            (_) async => const DataFailed(NetworkCancelException()));
        return remoteArticlesBloc;
      },
      act: (bloc) => bloc.add(const GetArticles()),
      // DioException doesn't implement Equatable, so we use matchers:
      expect: () => const [
        RemoteArticlesLoading(),
        RemoteArticlesError(NetworkCancelException()),
      ],
      verify: (bloc) {
        verify(() => mockGetArticleUseCase.call(any())).called(1);
      },
    );
  });
}
