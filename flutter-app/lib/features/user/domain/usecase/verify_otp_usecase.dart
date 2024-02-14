import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/user/domain/repository/i_auth_repository.dart';

class VerifyOTP extends UsecaseWithParam<void, CustomVerificationParam> {
  final IAuthRepository authRepository;
  const VerifyOTP({required this.authRepository});
  @override
  ResultFuture<PhoneAuthCredential> call(CustomVerificationParam param) async {
    return authRepository.verifyOTP(
        verificationId: param.verificationId, otp: param.otp);
  }
}

class CustomVerificationParam extends Equatable {
  final String verificationId;
  final String otp;
  const CustomVerificationParam(
      {required this.verificationId, required this.otp});
  @override
  List<Object?> get props => [
        otp,
        verificationId,
      ];
}
