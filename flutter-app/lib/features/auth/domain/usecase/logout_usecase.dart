import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';

class LogoutUser extends UsecaseWithoutParam {
  final IAuthRepository authRepository;
  const LogoutUser({required this.authRepository});
  @override
  FutureVoid call() {
    return authRepository.logout();
  }
}
