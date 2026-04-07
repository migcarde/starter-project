import 'dart:io';

import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/core/errors/local_database_exception.dart';
import 'package:news_app_clean_architecture/core/errors/network_exception.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final AppDatabase _appDatabase;
  ArticleRepositoryImpl(this._newsApiService, this._appDatabase);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioException catch (e) {
      return DataFailed(NetworkException.fromDioException(e));
    }
  }

  @override
  Future<DataState<List<ArticleModel>>> getSavedArticles() async {
    try {
      return DataSuccess(await _appDatabase.articleDAO.getArticles());
    } on DatabaseException catch (e) {
      return DataFailed(LocalDatabaseException.fromDatabaseException(e));
    }
  }

  @override
  Future<DataState<void>> removeArticle(ArticleEntity article) async {
    try {
      await _appDatabase.articleDAO
          .deleteArticle(ArticleModel.fromEntity(article));

      return const DataSuccess(null);
    } on DatabaseException catch (e) {
      return DataFailed(LocalDatabaseException.fromDatabaseException(e));
    }
  }

  @override
  Future<DataState<void>> saveArticle(ArticleEntity article) async {
    try {
      await _appDatabase.articleDAO
          .insertArticle(ArticleModel.fromEntity(article));

      return const DataSuccess(null);
    } on DatabaseException catch (e) {
      return DataFailed(LocalDatabaseException.fromDatabaseException(e));
    }
  }
}
