import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/errors/local_database_exception.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_status.dart';

import '../../../../domain/usecases/get_saved_articles.dart';
import '../../../../domain/usecases/remove_article.dart';
import '../../../../domain/usecases/save_article.dart';

class LocalArticleBloc extends Bloc<LocalArticlesEvent, LocalArticlesState> {
  final GetSavedArticlesUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleBloc(this._getSavedArticleUseCase, this._saveArticleUseCase,
      this._removeArticleUseCase)
      : super(const LocalArticlesLoading()) {
    on<GetSavedArticles>(onGetSavedArticles);
    on<RemoveArticle>(onRemoveArticle);
    on<SaveArticle>(onSaveArticle);
  }

  void onGetSavedArticles(
      GetSavedArticles event, Emitter<LocalArticlesState> emit) async {
    final dataState = await _getSavedArticleUseCase(NoParams());

    if (dataState is DataSuccess) {
      _emitData(
        emit: emit,
        articles: dataState.data ?? [],
        status: LocalArticleStatus.none,
      );
    } else {
      emit(LocalArticlesError(dataState.error! as LocalDatabaseException));
    }
  }

  void onRemoveArticle(
      RemoveArticle removeArticle, Emitter<LocalArticlesState> emit) async {
    await _removeArticleUseCase(removeArticle.article!);
    final articles = await _getSavedArticleUseCase(NoParams());

    if (articles is DataSuccess) {
      _emitData(
        emit: emit,
        articles: articles.data ?? [],
        status: LocalArticleStatus.deletedSuccess,
      );
      _clearSnackbar(emit: emit, state: state);
    } else if (state is LocalArticlesDone) {
      _showGenericErrorSnackbar(
        emit: emit,
        state: state as LocalArticlesDone,
      );
      _clearSnackbar(emit: emit, state: state);
    } else {
      emit(LocalArticlesError(articles.error! as LocalDatabaseException));
    }
  }

  void onSaveArticle(
      SaveArticle saveArticle, Emitter<LocalArticlesState> emit) async {
    await _saveArticleUseCase(saveArticle.article!);
    final articles = await _getSavedArticleUseCase(NoParams());

    if (articles is DataSuccess) {
      _emitData(
        emit: emit,
        articles: articles.data ?? [],
        status: LocalArticleStatus.savedSuccess,
      );
      _clearSnackbar(emit: emit, state: state);
    } else if (state is LocalArticlesDone) {
      _showGenericErrorSnackbar(
        emit: emit,
        state: state as LocalArticlesDone,
      );
      _clearSnackbar(emit: emit, state: state);
    } else {
      emit(LocalArticlesError(articles.error! as LocalDatabaseException));
    }
  }

  void _emitData({
    required Emitter<LocalArticlesState> emit,
    required List<ArticleEntity> articles,
    LocalArticleStatus status = LocalArticleStatus.none,
  }) =>
      emit(
        articles.isEmpty
            ? LocalArticleEmpty(
                status: status,
              )
            : LocalArticlesDone(
                articles: articles,
                status: status,
              ),
      );

  void _clearSnackbar({
    required Emitter<LocalArticlesState> emit,
    required LocalArticlesState state,
  }) {
    if (state is LocalArticlesDone) {
      emit(
        state.copyWith(
          articles: state.articles,
          status: LocalArticleStatus.none,
        ),
      );
    } else if (state is LocalArticleEmpty) {
      emit(
        state.copyWith(
          status: LocalArticleStatus.none,
        ),
      );
    }
  }

  void _showGenericErrorSnackbar({
    required Emitter<LocalArticlesState> emit,
    required LocalArticlesDone state,
  }) =>
      emit(
        state.copyWith(
          articles: state.articles,
          status: LocalArticleStatus.genericError,
        ),
      );
}
