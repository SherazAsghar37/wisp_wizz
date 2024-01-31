import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';

class GetCachedUser extends UsecaseWithoutParamSync {
  final IAuthRepository authRepository;
  const GetCachedUser({required this.authRepository});
  @override
  NullabeleUser call() {
    return authRepository.getCachedUser();
  }
}
