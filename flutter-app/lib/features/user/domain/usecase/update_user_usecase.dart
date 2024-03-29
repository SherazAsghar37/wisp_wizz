import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';

class UpdateUser extends UsecaseWithParam<UserModel, UpdateUserParam> {
  final IAuthRepository authRepository;
  const UpdateUser({required this.authRepository});
  @override
  FutureUser call(UpdateUserParam param) async {
    return authRepository.updateUser(
        name: param.name, id: param.id, image: param.image);
  }
}

class UpdateUserParam extends Equatable {
  final String? name;
  final String id;
  final Uint8List? image;
  const UpdateUserParam({
    required this.name,
    required this.id,
    required this.image,
  });

  @override
  List<Object?> get props => [
        name,
        id,
        image,
      ];
}
