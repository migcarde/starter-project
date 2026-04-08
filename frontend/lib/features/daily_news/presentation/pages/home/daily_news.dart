import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app_clean_architecture/config/routes/paths.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/publish_article/publish_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/base_scaffold.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/articles_list.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_bloc.dart';
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
            onPressed: () => context.pushNamed(Paths.savedArticles.name),
            icon: const Icon(Icons.bookmark, color: Colors.black),
          ),
          IconButton(
            onPressed: () => context.read<LoginBloc>().add(SignOutRequested()),
            icon: const Icon(Icons.logout, color: Colors.black),
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
        floatingActionButton: const _DailyNewsFloatingButton(),
      ),
    );
  }
}

class _DailyNewsFloatingButton extends FloatingActionButton {
  const _DailyNewsFloatingButton({super.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final loginState = context.read<LoginBloc>().state;

        if (loginState is LoggedIn) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (modalContext) => const PublishArticle(),
          );
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
