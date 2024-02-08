import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';

class LoginUser extends UsecaseWithParam<void, CustomUserParam> {
  final IAuthRepository authRepository;
  const LoginUser({required this.authRepository});
  @override
  FutureUser call(CustomUserParam param) async {
    return authRepository.loginUser(
        name: param.name, phoneNumber: param.phoneNumber, image: param.image);
  }
}

class CustomUserParam extends Equatable {
  final String? name;
  final String phoneNumber;
  final String? image;

  const CustomUserParam(
      {required this.name, required this.phoneNumber, required this.image});

  @override
  List<Object?> get props => [name, phoneNumber, image];
}
