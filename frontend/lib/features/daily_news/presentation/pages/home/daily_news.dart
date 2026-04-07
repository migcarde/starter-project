import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/base_scaffold.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/articles_list.dart';
import 'package:news_app_clean_architecture/injection_container.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Add default theme
    return BlocProvider(
      create: (context) => sl<RemoteArticlesBloc>()..add(const GetArticles()),
      child: BaseScaffold(
        text: 'Daily News',
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/SavedArticles'),
            icon: const Icon(Icons.bookmark, color: Colors.black),
          ),
        ],
        body: RefreshIndicator(
          onRefresh: () async => context.read<RemoteArticlesBloc>().add(
                const GetArticles(),
              ),
          child: BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
            builder: (context, state) => switch (state) {
              RemoteArticlesLoading() =>
                const Center(child: CupertinoActivityIndicator()),
              RemoteArticlesError() => const Center(
                  child:
                      Icon(Icons.refresh)), // TODO: Add a generic error widget
              RemoteArticlesDone() => ArticlesList(
                  articles: state.articles ?? [],
                ),
              RemoteArticleEmpty() =>
                const Center(child: Text('No articles found')),
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: REPLACE ROUTE WITH YOUR "ADD ARTICLE" PAGE
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
