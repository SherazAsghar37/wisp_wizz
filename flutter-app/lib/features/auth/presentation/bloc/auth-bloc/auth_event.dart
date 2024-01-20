part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendCodeEvent extends AuthEvent {
  final String countryCode;
  final int phoneNumber;
  const SendCodeEvent({required this.countryCode, required this.phoneNumber});
  @override
  List<Object> get props => [countryCode, phoneNumber];
}

class VerifyOTPEvent extends AuthEvent {
  final int otp;
  final int phoneNumber;
  const VerifyOTPEvent({required this.otp, required this.phoneNumber});
  @override
  List<Object> get props => [otp, phoneNumber];
}

class LoginEvent extends AuthEvent {
  final String name;
  final int phoneNumber;
  final String countryCode;
  final File? image;
  const LoginEvent({
    required this.phoneNumber,
    required this.countryCode,
    required this.name,
    this.image,
  });
  @override
  List<Object> get props => [
        phoneNumber,
        phoneNumber,
        countryCode,
      ];
}
