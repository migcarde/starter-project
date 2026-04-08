import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/errors/network_exception.dart';
import 'package:news_app_clean_architecture/core/extensions/list_extensions.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_articles.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_status.dart';

class RemoteArticlesBloc
    extends Bloc<RemoteArticlesEvent, RemoteArticlesState> {
  final GetArticlesUseCase _getArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;

  RemoteArticlesBloc(
    this._getArticleUseCase,
    this._saveArticleUseCase,
  ) : super(const RemoteArticlesLoading()) {
    on<GetArticles>(_onGetArticles);
    on<CreateArticle>(_onCreateArticle);
  }

  Future<void> _onGetArticles(
      GetArticles event, Emitter<RemoteArticlesState> emit) async {
    emit(const RemoteArticlesLoading());

    final dataState = await _getArticleUseCase(NoParams());

    if (dataState is DataSuccess) {
      emit(
        dataState.data.isNullOrEmpty
            ? const RemoteArticleEmpty()
            : RemoteArticlesDone(
                articles: dataState.data ?? [],
              ),
      );
    } else {
      emit(RemoteArticlesError(dataState.error! as NetworkException));
    }
  }

  Future<void> _onCreateArticle(
      CreateArticle event, Emitter<RemoteArticlesState> emit) async {
    final dataState = await _saveArticleUseCase(event.article);

    final isSuccess = dataState is DataSuccess;
    final status = isSuccess
        ? RemoteArticleStatus.createdArticleSuccess
        : RemoteArticleStatus.genericError;

    emit(
      isSuccess
          ? RemoteArticlesDone(
              articles: state.articles ?? [],
              status: status,
            )
          : RemoteArticleEmpty(
              status: status,
            ),
    );
    _clearSnackbar(emit, state);
  }

  void _clearSnackbar(
          Emitter<RemoteArticlesState> emit, RemoteArticlesState state) =>
      emit(
        state is RemoteArticlesDone
            ? RemoteArticlesDone(
                articles: state.articles ?? [],
                status: RemoteArticleStatus.none,
              )
            : const RemoteArticleEmpty(
                status: RemoteArticleStatus.none,
              ),
      );
}
