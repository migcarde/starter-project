import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/login/domain/entities/user.dart';
import 'package:news_app_clean_architecture/features/login/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  // TODO: implement loginStream
  Stream<UserEntity?> get loginStream => throw UnimplementedError();

  @override
  Future<DataState<UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
