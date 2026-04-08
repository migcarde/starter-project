import 'package:flutter/widgets.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

@immutable
sealed class RemoteArticlesEvent {
  const RemoteArticlesEvent();
}

final class GetArticles extends RemoteArticlesEvent {
  const GetArticles();
}

final class CreateArticle extends RemoteArticlesEvent {
  final ArticleEntity article;

  const CreateArticle({required this.article});
}
