part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

//logout
final class AuthLoggingout extends AuthState {
  const AuthLoggingout();
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

final class AuthFailedToLogout extends AuthState {
  final String message;
  const AuthFailedToLogout(this.message);
  @override
  List<Object> get props => [message];
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

//get user
final class AuthGettingUser extends AuthState {
  const AuthGettingUser();
}

final class AuthUserFound extends AuthState {
  final UserModel user;
  const AuthUserFound({required this.user});
  @override
  List<Object> get props => [user];
}

final class AuthUserNotFound extends AuthState {
  const AuthUserNotFound();
}

final class AuthFailedToGetUser extends AuthState {
  final String message;
  const AuthFailedToGetUser(this.message);
  @override
  List<Object> get props => [message];
}

//login
final class AuthloggingIn extends AuthState {
  const AuthloggingIn();
}

final class AuthloggedIn extends AuthState {
  final UserModel user;
  const AuthloggedIn({required this.user});
  @override
  List<Object> get props => [user];
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
