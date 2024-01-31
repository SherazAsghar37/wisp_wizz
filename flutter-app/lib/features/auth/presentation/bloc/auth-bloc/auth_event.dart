part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendCodeEvent extends AuthEvent {
  final String countryCode;
  final String phoneNumber;
  const SendCodeEvent({required this.countryCode, required this.phoneNumber});
  @override
  List<Object> get props => [countryCode, phoneNumber];
}

class VerifyOTPEvent extends AuthEvent {
  final String otp;
  const VerifyOTPEvent({
    required this.otp,
  });
  @override
  List<Object> get props => [otp];
}

class GetUserEvent extends AuthEvent {
  final String phoneNumber;
  final String countryCode;
  const GetUserEvent({
    required this.phoneNumber,
    required this.countryCode,
  });
  @override
  List<Object> get props => [phoneNumber, countryCode];
}

class LoginEvent extends AuthEvent {
  final String? name;
  final String phoneNumber;
  final String countryCode;
  final String? image;
  const LoginEvent({
    required this.phoneNumber,
    required this.countryCode,
    required this.name,
    this.image,
  });
  @override
  List<Object> get props => [
        phoneNumber,
        countryCode,
      ];
}

class GetCachedUserEvent extends AuthEvent {
  const GetCachedUserEvent();
}
