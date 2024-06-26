import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';

class LoginUser extends UsecaseWithParam<UserModel, CustomUserParam> {
  final IAuthRepository authRepository;
  const LoginUser({required this.authRepository});
  @override
  FutureUser call(CustomUserParam param) async {
    return authRepository.loginUser(
      name: param.name,
      phoneNumber: param.phoneNumber,
      image: param.image,
    );
  }
}

class CustomUserParam extends Equatable {
  final String? name;
  final String phoneNumber;
  final Uint8List? image;
  const CustomUserParam({
    required this.name,
    required this.phoneNumber,
    required this.image,
  });

  @override
  List<Object?> get props => [
        name,
        phoneNumber,
        image,
      ];
}
