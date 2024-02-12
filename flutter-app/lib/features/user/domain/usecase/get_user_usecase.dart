import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';

class GetUser extends UsecaseWithParam<void, CustomGetUserParam> {
  final IAuthRepository authRepository;
  const GetUser({required this.authRepository});
  @override
  FutureNullabeleUser call(CustomGetUserParam param) async {
    return authRepository.getUser(phoneNumber: param.phoneNumber);
  }
}

class CustomGetUserParam extends Equatable {
  final String phoneNumber;
  const CustomGetUserParam({
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        phoneNumber,
      ];
}
