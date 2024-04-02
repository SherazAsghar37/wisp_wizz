import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';

class DisconnectSocketUsecase extends UsecaseWithoutParamSync<void> {
  final IAuthRepository authRepository;
  const DisconnectSocketUsecase({required this.authRepository});
  @override
  Result<void> call() {
    return authRepository.disconnectSocket();
  }
}
