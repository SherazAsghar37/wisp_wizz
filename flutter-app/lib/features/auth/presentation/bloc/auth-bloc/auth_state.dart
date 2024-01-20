part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

//sending code
final class AuthSendingCode extends AuthState {
  const AuthSendingCode();
}

final class AuthCodeSent extends AuthState {
  const AuthCodeSent();
}

final class AuthCodeSentFailed extends AuthState {
  final String message;
  const AuthCodeSentFailed(this.message);
  @override
  List<Object> get props => [message];
}

//verification
final class AuthVerifyingOTP extends AuthState {
  const AuthVerifyingOTP();
}

final class AuthOTPVerified extends AuthState {
  const AuthOTPVerified();
}

final class AuthOTPVerificationFailed extends AuthState {
  final String message;
  const AuthOTPVerificationFailed(this.message);
  @override
  List<Object> get props => [message];
}

//login

//verification
final class AuthloggingIn extends AuthState {
  const AuthloggingIn();
}

final class AuthloggedIn extends AuthState {
  const AuthloggedIn();
}

final class AuthloginFailed extends AuthState {
  final String message;
  const AuthloginFailed(this.message);
  @override
  List<Object> get props => [message];
}

final class AuthResponse extends AuthState {
  final String message;
  const AuthResponse(this.message);
  @override
  List<Object> get props => [message];
}
