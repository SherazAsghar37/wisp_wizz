import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';

class GetUser extends UsecaseWithParam<void, CustomGetUserParam> {
  final IAuthRepository authRepository;
  const GetUser({required this.authRepository});
  @override
  FutureNullabeleUser call(CustomGetUserParam param) async {
    return authRepository.getUser(
        phoneNumber: param.phoneNumber, countryCode: param.countryCode);
  }
}

class CustomGetUserParam extends Equatable {
  final int phoneNumber;
  final String countryCode;
  const CustomGetUserParam({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}
