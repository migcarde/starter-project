import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_tile.dart';

class DailyNewsContent extends StatelessWidget {
  const DailyNewsContent({
    super.key,
    required this.articles,
  });

  final List<ArticleEntity> articles;

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
            onArticlePressed: (article) => Navigator.pushNamed(
              context,
              '/ArticleDetails', // TODO: Add named routes
              arguments: article,
            ),
            onRemove: (article) {},
          ),
        );
      },
    );
  }
}
