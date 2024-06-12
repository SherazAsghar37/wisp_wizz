import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';

class DeleteUser extends UsecaseWithParam<void, String> {
  final IAuthRepository authRepository;
  const DeleteUser({required this.authRepository});
  @override
  FutureVoid call(String param) async {
    return authRepository.deleteUser(id: param);
  }
}
