import 'dart:io';

import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/domain/repository/auth_repository.dart';

class LoginUser extends UsecaseWithParam<void, CustomUserParam> {
  final IAuthRepository authRepository;
  const LoginUser({required this.authRepository});
  @override
  FutureVoid call(CustomUserParam param) async {
    return authRepository.loginUser(
        countryCode: param.countryCode,
        name: param.name,
        phoneNumber: param.phoneNumber,
        image: param.image);
  }
}

class CustomUserParam {
  final String name;
  final int phoneNumber;
  final String countryCode;
  final File? image;

  CustomUserParam(
      {required this.countryCode,
      required this.name,
      required this.phoneNumber,
      required this.image});
}
