import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/constants/dimens.dart';
import '../../domain/entities/article.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity article;
  final bool isRemovable;
  final Function(ArticleEntity article) onRemove;
  final Function(ArticleEntity article) onArticlePressed;

  static const _heightFactor = 2.2;
  static const _titleMaxLines = 3;
  static const _descriptionMaxLines = 2;

  const ArticleWidget({
    Key? key,
    required this.article,
    required this.onRemove,
    required this.onArticlePressed,
    this.isRemovable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onArticlePressed(article),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: Dimens.m,
          vertical: Dimens.s,
        ),
        height: MediaQuery.sizeOf(context).width / _heightFactor,
        child: Row(
          children: [
            ArticleTileImage(article: article),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            article.title ?? '',
                            maxLines: _titleMaxLines,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Butler',
                              fontWeight: FontWeight.w900,
                              fontSize: 18, //TODO: Replace with theme
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (isRemovable)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: Dimens.xs,
                            ),
                            child: GestureDetector(
                              onTap: () => onRemove(article),
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),

                    // Description
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: Dimens.xs),
                        child: Text(
                          article.description ?? '',
                          maxLines: _descriptionMaxLines,
                        ),
                      ),
                    ),

                    // Datetime
                    Row(
                      children: [
                        const Icon(
                          Icons.timeline_outlined,
                          size: Dimens.m,
                        ),
                        const SizedBox(width: Dimens.s),
                        Text(
                          article.publishedAt!,
                          style: const TextStyle(
                            fontSize: 12, // TODO: Replace with theme
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleTileImage extends StatelessWidget {
  const ArticleTileImage({
    super.key,
    required this.article,
  });

  final ArticleEntity? article;

  static const _widthFactor = 3;
  static const _imageAlpha = 0.08;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: article!.urlToImage!,
      imageBuilder: (context, imageProvider) => Padding(
        padding: const EdgeInsetsDirectional.only(end: Dimens.m),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Container(
            width: MediaQuery.sizeOf(context).width / _widthFactor,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: _imageAlpha),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
        padding: const EdgeInsetsDirectional.only(end: Dimens.m),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Container(
            width: MediaQuery.sizeOf(context).width / _widthFactor,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: _imageAlpha),
            ),
            child: const CupertinoActivityIndicator(),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Padding(
        padding: const EdgeInsetsDirectional.only(end: Dimens.m),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: Container(
            width: MediaQuery.sizeOf(context).width / _widthFactor,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: _imageAlpha),
            ),
            child: const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
