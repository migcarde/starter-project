import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:news_app_clean_architecture/core/errors/network_exception.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_status.dart';

@immutable
sealed class RemoteArticlesState extends Equatable {
  final RemoteArticleStatus status;
  final List<ArticleEntity>? articles;
  final NetworkException? error;

  const RemoteArticlesState({
    this.status = RemoteArticleStatus.none,
    this.articles,
    this.error,
  });

  @override
  List<Object?> get props => [
        status,
        articles,
        error,
      ];
}

final class RemoteArticlesLoading extends RemoteArticlesState {
  const RemoteArticlesLoading();
}

final class RemoteArticlesDone extends RemoteArticlesState {
  const RemoteArticlesDone({
    required List<ArticleEntity> articles,
    RemoteArticleStatus status = RemoteArticleStatus.none,
  }) : super(articles: articles, status: status);

  @override
  List<Object?> get props => [
        articles,
        status,
      ];
}

final class RemoteArticlesError extends RemoteArticlesState {
  const RemoteArticlesError(NetworkException error) : super(error: error);

  @override
  List<Object?> get props => [error];
}

final class RemoteArticleEmpty extends RemoteArticlesState {
  const RemoteArticleEmpty({
    RemoteArticleStatus status = RemoteArticleStatus.none,
  }) : super(status: status);
}
