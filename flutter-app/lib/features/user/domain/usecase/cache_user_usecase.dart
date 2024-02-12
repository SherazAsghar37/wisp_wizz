import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/calls/presentation/utils/exports.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';

class CacheUser extends UsecaseWithParam<void, UserModel> {
  final IAuthRepository authRepository;
  const CacheUser({required this.authRepository});
  @override
  ResultFuture<void> call(UserModel param) {
    return authRepository.cacheUser(param);
  }
}
