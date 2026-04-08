import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_clean_architecture/core/constants/dimens.dart';
import 'package:news_app_clean_architecture/core/extensions/context_extensions.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_status.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/button/base_button.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/button/button_size.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/button/loading_button.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/text_field/base_markdown_text_field.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/text_field/base_text_field.dart';
import 'package:news_app_clean_architecture/features/login/presentation/bloc/login_bloc.dart';
import 'package:news_app_clean_architecture/injection_container.dart';
import 'package:permission_handler/permission_handler.dart';

class PublishArticle extends StatelessWidget {
  const PublishArticle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RemoteArticlesBloc>(),
      child: const _PublishArticleBody(),
    );
  }
}

class _PublishArticleBody extends StatefulWidget {
  const _PublishArticleBody();

  @override
  State<_PublishArticleBody> createState() => _PublishArticleBodyState();
}

class _PublishArticleBodyState extends State<_PublishArticleBody> {
  final _titleController = TextEditingController();
  final _articleController = TextEditingController();

  bool _isLoading = false;
  bool _titleIsEmpty = false;
  bool _photoIsEmpty = false;
  bool _articleIsEmpty = false;

  XFile? _photo;

  static const _imageHeight = 200.0;

  @override
  void dispose() {
    _titleController.dispose();
    _articleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return BlocListener<RemoteArticlesBloc, RemoteArticlesState>(
      listenWhen: (previous, current) =>
          current is RemoteArticlesDone &&
          current.status != RemoteArticleStatus.none,
      listener: (context, state) {
        switch (state.status) {
          case RemoteArticleStatus.createdArticleSuccess:
            context.pop();
            context.showSnackBar(
              message: 'PUBLISHED ARTICLE',
              backgroundColor: Colors.black,
            );
            context.read<RemoteArticlesBloc>().add(const GetArticles());

            break;
          case RemoteArticleStatus.genericError:
            context.pop();
            context.showSnackBar(
              message: 'GENERIC ERROR',
              backgroundColor: Colors.red,
            );
            context.read<RemoteArticlesBloc>().add(const GetArticles());

            break;
          case RemoteArticleStatus.none:
            break;
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: Dimens.l,
          start: Dimens.screenPaddingHorizontal,
          end: Dimens.screenPaddingHorizontal,
          bottom: MediaQuery.of(context).viewInsets.bottom + Dimens.l,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BaseTextField(
                controller: _titleController,
                hint: 'Write your title here...',
                errorText: _titleIsEmpty ? 'Required field' : null,
                maxLength: 100,
              ),
              // TODO: Use figma SVG for this
              Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.m,
                ),
                child: Column(
                  children: [
                    if (_photo == null)
                      BaseButton(
                        text: 'Attach Image',
                        leftSvgPath: 'assets/svgs/camera_plus.svg',
                        size: ButtonSize.small,
                        onTap: () async {
                          final permission = await Permission.camera.status;

                          if (!permission.isGranted) {
                            final requestPermission =
                                await Permission.camera.request();

                            if (requestPermission.isGranted) {
                              return;
                            }
                          }

                          final picker = ImagePicker();
                          final photo = await picker.pickImage(
                              source: ImageSource.camera);

                          setState(() {
                            _photo = photo;
                          });
                        },
                      ),
                    if (_photoIsEmpty)
                      Text(
                        'Required field',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    if (_photo != null)
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(
                          Dimens.cardRadius,
                        ),
                        child: Image.file(
                          File(_photo!.path),
                          width: double.maxFinite,
                          height: _imageHeight,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.m,
                ),
                child: BaseMarkdownTextField(
                  controller: _articleController,
                  hint: 'Add article here...',
                  maxLines: 5,
                  errorText: _articleIsEmpty ? 'Required field' : null,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: Dimens.l),
                child: LoadingButton(
                  text: 'Publish article',
                  onTap: () {
                    final userState = context.read<LoginBloc>().state;
                    final titleIsEmpty = _titleController.text.isEmpty;
                    // TODO: Check attached file
                    final articleIsEmpty = _articleController.text.isEmpty;

                    if (!_isLoading &&
                        (titleIsEmpty || articleIsEmpty || _photo == null)) {
                      setState(() {
                        _titleIsEmpty = titleIsEmpty;
                        _articleIsEmpty = articleIsEmpty;
                        _photoIsEmpty = _photo == null;
                      });
                    } else if (!_isLoading && userState is LoggedIn) {
                      setState(() {
                        _isLoading = true;
                      });

                      final article = ArticleEntity(
                        author: userState.user.email,
                        title: _titleController.text,
                        description: _articleController.text.substring(
                          0,
                          _articleController.text.length > 200
                              ? 200
                              : _articleController.text.length,
                        ),
                        content: _articleController.text,
                        publishedAt: DateTime.now().toString(),
                      );

                      context.read<RemoteArticlesBloc>().add(
                            CreateArticle(article: article),
                          );
                    }
                  },
                  isLoading: _isLoading,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
