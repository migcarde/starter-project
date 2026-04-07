import 'package:equatable/equatable.dart';
import 'package:news_app_clean_architecture/core/errors/network_exception.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

sealed class RemoteArticlesState extends Equatable {
  final List<ArticleEntity>? articles;
  final NetworkException? error;

  const RemoteArticlesState({this.articles, this.error});

  @override
  List<Object?> get props => [];
}

class RemoteArticlesLoading extends RemoteArticlesState {
  const RemoteArticlesLoading();
}

class RemoteArticlesDone extends RemoteArticlesState {
  const RemoteArticlesDone(List<ArticleEntity> articles)
      : super(articles: articles);

  @override
  List<Object?> get props => [articles];
}

class RemoteArticlesError extends RemoteArticlesState {
  const RemoteArticlesError(NetworkException error) : super(error: error);

  @override
  List<Object?> get props => [error];
}

class RemoteArticleEmpty extends RemoteArticlesState {
  const RemoteArticleEmpty();
}
