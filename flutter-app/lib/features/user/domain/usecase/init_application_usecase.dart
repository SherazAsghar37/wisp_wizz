import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/app/shared/entities/user_entity.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';

class InitApplication extends UsecaseWithoutParam<void> {
  final IAuthRepository authRepository;
  const InitApplication({required this.authRepository});
  @override
  ResultFuture<UserEntity?> call() {
    return authRepository.initApplication();
  }
}
