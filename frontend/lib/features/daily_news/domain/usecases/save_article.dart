import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

class SaveArticleUseCase implements UseCase<DataState<void>, ArticleEntity> {
  final ArticleRepository _articleRepository;

  SaveArticleUseCase(this._articleRepository);

  @override
  Future<DataState<void>> call(ArticleEntity params) async {
    // TOOD: Replace with actual implementation
    return const DataSuccess(null);
    // return _articleRepository.saveArticle(params!);
  }
}
