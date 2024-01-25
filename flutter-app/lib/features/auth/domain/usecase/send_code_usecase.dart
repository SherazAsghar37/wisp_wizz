import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';

class SendCode extends UsecaseWithParam<void, CustomPhoneParam> {
  final IAuthRepository authRepository;
  const SendCode({required this.authRepository});
  @override
  ResultFuture<CustomPhoneResoponse> call(CustomPhoneParam param) async {
    return authRepository.sendCode(
        phoneNumber: param.phoneNumber, countryCode: param.countryCode);
  }
}

class CustomPhoneParam extends Equatable {
  final String phoneNumber;
  final String countryCode;
  const CustomPhoneParam({
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}

class CustomPhoneResoponse extends Equatable implements ICustomPhoneResponse {
  @override
  final String verificationId;
  @override
  final PhoneAuthCredential? phoneAuthCredential;
  const CustomPhoneResoponse(
      {required this.verificationId, this.phoneAuthCredential});
  @override
  List<Object?> get props => [verificationId, phoneAuthCredential];
}
