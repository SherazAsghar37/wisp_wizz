part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendCodeEvent extends AuthEvent {
  final String phoneNumber;
  const SendCodeEvent({required this.phoneNumber});
  @override
  List<Object> get props => [phoneNumber];
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
  const GetUserEvent({
    required this.phoneNumber,
  });
  @override
  List<Object> get props => [
        phoneNumber,
      ];
}

class LoginEvent extends AuthEvent {
  final String? name;
  final String phoneNumber;
  final Uint8List? image;
  const LoginEvent({
    required this.phoneNumber,
    required this.name,
    this.image,
  });
  @override
  List<Object> get props => [
        phoneNumber,
      ];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class GetCachedUserEvent extends AuthEvent {
  const GetCachedUserEvent();
}
