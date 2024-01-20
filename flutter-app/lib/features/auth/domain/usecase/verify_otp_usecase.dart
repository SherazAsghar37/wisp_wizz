import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/domain/repository/i_auth_repository.dart';

class VerifyOTP extends UsecaseWithParam<void, CustomVerificationParam> {
  final IAuthRepository authRepository;
  const VerifyOTP({required this.authRepository});
  @override
  FutureVoid call(CustomVerificationParam param) async {
    return authRepository.verifyOTP(
        phoneNumber: param.phoneNumber, otp: param.otp);
  }
}

class CustomVerificationParam extends Equatable {
  final int phoneNumber;
  final int otp;
  const CustomVerificationParam({
    required this.phoneNumber,
    required this.otp,
  });
  @override
  List<Object?> get props => [
        otp,
        phoneNumber,
      ];
}
