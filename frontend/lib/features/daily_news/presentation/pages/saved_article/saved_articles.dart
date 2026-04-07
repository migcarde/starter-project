import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/extensions/context_extensions.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_status.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/base_scaffold.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/articles_list.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

class SavedArticles extends StatelessWidget {
  const SavedArticles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticles()),
      child: BaseScaffold.withBackNavigation(
        text: 'Saved Articles',
        body: BlocConsumer<LocalArticleBloc, LocalArticlesState>(
          listenWhen: (previous, current) =>
              current is LocalArticlesDone &&
              current.status != LocalArticleStatus.none,
          listener: (context, state) {
            switch (state.status) {
              case LocalArticleStatus.savedSuccess:
                context.showSnackBar(
                  message: 'SAVED ARTICLE',
                  backgroundColor: Colors.black,
                );
              case LocalArticleStatus.deletedSuccess:
                context.showSnackBar(
                  message: 'DELETED ARTICLE',
                  backgroundColor: Colors.black,
                );
              case LocalArticleStatus.genericError:
                context.showSnackBar(
                  message: 'GENERIC ERROR',
                  backgroundColor: Colors.red,
                );
              case LocalArticleStatus.none:
                break;
            }
          },
          builder: (context, state) => switch (state) {
            LocalArticlesLoading() => const Center(
                child: CupertinoActivityIndicator(),
              ),
            LocalArticlesDone() => ArticlesList(
                articles: state.articles ?? [],
                isRemovable: true,
                onRemove: (article) => context.read<LocalArticleBloc>().add(
                      RemoveArticle(article),
                    ),
              ),
            LocalArticleEmpty() => const Center(
                child: Text(
                  'NO SAVED ARTICLES',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            LocalArticlesError() => const Center(
                child: Text(
                  'ERROR',
                  style: TextStyle(color: Colors.black),
                ),
              ),
          },
        ),
      ),
    );
  }
}
