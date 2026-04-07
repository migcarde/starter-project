import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/errors/local_database_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_status.dart';

class MockGetSavedArticleUseCase extends Mock
    implements GetSavedArticleUseCase {}

class MockSaveArticleUseCase extends Mock implements SaveArticleUseCase {}

class MockRemoveArticleUseCase extends Mock implements RemoveArticleUseCase {}

class FakeArticleEntity extends Fake implements ArticleEntity {}

void main() {
  late MockGetSavedArticleUseCase mockGetSavedArticleUseCase;
  late MockSaveArticleUseCase mockSaveArticleUseCase;
  late MockRemoveArticleUseCase mockRemoveArticleUseCase;
  late LocalArticleBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeArticleEntity());
  });

  setUp(() {
    mockGetSavedArticleUseCase = MockGetSavedArticleUseCase();
    mockSaveArticleUseCase = MockSaveArticleUseCase();
    mockRemoveArticleUseCase = MockRemoveArticleUseCase();

    bloc = LocalArticleBloc(
      mockGetSavedArticleUseCase,
      mockSaveArticleUseCase,
      mockRemoveArticleUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const testArticle = ArticleEntity(
    id: 1,
    title: 'Test Title',
    author: 'Test Author',
    description: 'Test Description',
  );

  final testArticles = [testArticle];
  const dbError = LocalDatabaseUnknownException(message: 'DB Error');

  group('GetSavedArticles', () {
    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits [LocalArticlesDone] when data fetching is successful and list is not empty',
      build: () {
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => DataSuccess(testArticles));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetSavedArticles()),
      expect: () => [
        LocalArticlesDone(
            articles: testArticles, status: LocalArticleStatus.none),
      ],
      verify: (_) {
        verify(() => mockGetSavedArticleUseCase.call()).called(1);
      },
    );

    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits [LocalArticleEmpty] when data fetching is successful but list is empty',
      build: () {
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => const DataSuccess([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetSavedArticles()),
      expect: () => [
        const LocalArticleEmpty(status: LocalArticleStatus.none),
      ],
    );

    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits [LocalArticlesError] when data fetching fails',
      build: () {
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => const DataFailed(dbError));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetSavedArticles()),
      expect: () => [
        const LocalArticlesError(dbError),
      ],
    );
  });

  group('SaveArticle', () {
    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits Success status then resets status when saving is successful and articles are NOT empty',
      build: () {
        when(() => mockSaveArticleUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(null));
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => DataSuccess(testArticles));
        return bloc;
      },
      act: (bloc) => bloc.add(const SaveArticle(testArticle)),
      expect: () => [
        LocalArticlesDone(
            articles: testArticles, status: LocalArticleStatus.savedSuccess),
        LocalArticlesDone(
            articles: testArticles, status: LocalArticleStatus.none),
      ],
      verify: (_) {
        verify(() => mockSaveArticleUseCase.call(params: testArticle))
            .called(1);
        verify(() => mockGetSavedArticleUseCase.call()).called(1);
      },
    );

    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits Success status then resets status when saving is successful and articles are empty',
      build: () {
        when(() => mockSaveArticleUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(null));
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => const DataSuccess([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const SaveArticle(testArticle)),
      expect: () => const [
        LocalArticleEmpty(status: LocalArticleStatus.savedSuccess),
        LocalArticleEmpty(status: LocalArticleStatus.none),
      ],
      verify: (_) {
        verify(() => mockSaveArticleUseCase.call(params: testArticle))
            .called(1);
        verify(() => mockGetSavedArticleUseCase.call()).called(1);
      },
    );

    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits generic error status then resets status when saving fails and current state is LocalArticlesDone',
      build: () {
        when(() => mockSaveArticleUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(null));
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => const DataFailed(dbError));
        return bloc;
      },
      seed: () => LocalArticlesDone(articles: testArticles),
      act: (bloc) => bloc.add(const SaveArticle(testArticle)),
      expect: () => [
        LocalArticlesDone(
            articles: testArticles, status: LocalArticleStatus.genericError),
        LocalArticlesDone(
            articles: testArticles, status: LocalArticleStatus.none),
      ],
    );

    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits LocalArticlesError when saving fails and current state is NOT LocalArticlesDone',
      build: () {
        when(() => mockSaveArticleUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(null));
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => const DataFailed(dbError));
        return bloc;
      },
      act: (bloc) => bloc.add(const SaveArticle(testArticle)),
      expect: () => [
        const LocalArticlesError(dbError),
      ],
    );
  });

  group('RemoveArticle', () {
    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits deletedSuccess status then resets status when removal is successful and articles list gets empty',
      build: () {
        when(() => mockRemoveArticleUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(null));
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => const DataSuccess([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const RemoveArticle(testArticle)),
      expect: () => [
        const LocalArticleEmpty(status: LocalArticleStatus.deletedSuccess),
        const LocalArticleEmpty(status: LocalArticleStatus.none),
      ],
      verify: (_) {
        verify(() => mockRemoveArticleUseCase.call(params: testArticle))
            .called(1);
        verify(() => mockGetSavedArticleUseCase.call()).called(1);
      },
    );

    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits generic error status then resets status when removal fails and current state is LocalArticlesDone',
      build: () {
        when(() => mockRemoveArticleUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(null));
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => const DataFailed(dbError));
        return bloc;
      },
      seed: () => LocalArticlesDone(articles: testArticles),
      act: (bloc) => bloc.add(const RemoveArticle(testArticle)),
      expect: () => [
        LocalArticlesDone(
            articles: testArticles, status: LocalArticleStatus.genericError),
        LocalArticlesDone(
            articles: testArticles, status: LocalArticleStatus.none),
      ],
    );

    blocTest<LocalArticleBloc, LocalArticlesState>(
      'emits LocalArticlesError when removal fails and current state is NOT LocalArticlesDone',
      build: () {
        when(() => mockRemoveArticleUseCase.call(params: any(named: 'params')))
            .thenAnswer((_) async => const DataSuccess(null));
        when(() => mockGetSavedArticleUseCase.call())
            .thenAnswer((_) async => const DataFailed(dbError));
        return bloc;
      },
      act: (bloc) => bloc.add(const RemoveArticle(testArticle)),
      expect: () => [
        const LocalArticlesError(dbError),
      ],
    );
  });
}
