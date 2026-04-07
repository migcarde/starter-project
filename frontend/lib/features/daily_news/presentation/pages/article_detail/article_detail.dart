import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/core/constants/dimens.dart';
import 'package:news_app_clean_architecture/core/extensions/context_extensions.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/base_network_image.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/base_scaffold.dart';
import 'package:news_app_clean_architecture/injection_container.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';

class ArticleDetailsView extends StatelessWidget {
  const ArticleDetailsView({super.key, required this.article});

  final ArticleEntity article;

  static const _imageHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LocalArticleBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<RemoteArticlesBloc>(),
        ),
      ],
      child: BaseScaffold.withBackNavigation(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: Dimens.xxl),
          child: Column(
            children: [
              _ArticleDetailTitleAndDate(
                title: article.title ?? '',
                publishedAt: article.publishedAt ?? '',
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: Dimens.s),
                child: BaseNetworkImage(
                  imageUrl: article.urlToImage!,
                  width: double.maxFinite,
                  height: _imageHeight,
                ),
              ),
              if (article.description != null &&
                  article.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: Dimens.screenPaddingHorizontal,
                    vertical: Dimens.m,
                  ),
                  child: Text(
                    article.description ?? '',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: Dimens.screenPaddingHorizontal,
                ),
                child: MarkdownBody(
                  data: article.content ?? '',
                  shrinkWrap: true,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _ArticleDetailFloatingButton(article: article),
      ),
    );
  }
}

class _ArticleDetailFloatingButton extends FloatingActionButton {
  const _ArticleDetailFloatingButton({
    required this.article,
    super.onPressed,
  });

  final ArticleEntity article;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        onPressed?.call();
        context.read<LocalArticleBloc>().add(SaveArticle(article));
        context.showSnackBar(
          message: 'Article saved successfully.',
          backgroundColor: Colors.black,
        );
      },
      child: const Icon(Ionicons.bookmark),
    );
  }
}

class _ArticleDetailTitleAndDate extends StatelessWidget {
  const _ArticleDetailTitleAndDate({
    required this.title,
    required this.publishedAt,
  });

  final String title;
  final String publishedAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.screenPaddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Butler',
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: Dimens.s),
          // DateTime
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Ionicons.time_outline, size: Dimens.m),
              const SizedBox(width: Dimens.xs),
              Text(
                publishedAt,
                style: const TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
