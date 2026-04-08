import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app_clean_architecture/config/routes/paths.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_tile.dart';

class ArticlesList extends StatelessWidget {
  const ArticlesList({
    super.key,
    required this.articles,
    this.isRemovable = false,
    this.onRemove,
  });

  final List<ArticleEntity> articles;
  final bool isRemovable;
  final Function(ArticleEntity)? onRemove;

  @override
  Widget build(BuildContext context) {
    // TODO: Add a loader at the end of the list
    // TODO: Add lazy loading for more articles at the end

    return ListView.builder(
      itemCount: articles.length,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: ArticleWidget(
            article: articles[index],
            isRemovable: isRemovable,
            onArticlePressed: (article) => context.pushNamed(
              Paths.articleDetails.name,
              extra: article,
            ),
            onRemove: (article) {
              if (isRemovable) {
                onRemove?.call(article);
              }
            },
          ),
        );
      },
    );
  }
}
