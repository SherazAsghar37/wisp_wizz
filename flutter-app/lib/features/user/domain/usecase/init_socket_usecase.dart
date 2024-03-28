import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';

class InitSocketUsecase extends UsecaseWithParamSync<void, String> {
  final IAuthRepository authRepository;
  const InitSocketUsecase({required this.authRepository});
  @override
  Result<void> call(String param) {
    return authRepository.initSocket(param);
  }
}
