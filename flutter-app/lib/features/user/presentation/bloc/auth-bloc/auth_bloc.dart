// ignore: depend_on_referenced_packages
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/config/extensions.dart';
import 'package:wisp_wizz/features/user/data/models/user_model.dart';
import 'package:wisp_wizz/features/user/domain/usecase/cache_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/get_cached_user.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/user/domain/usecase/get_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/init_application_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/logout_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/update_user_usecase.dart';
import 'package:wisp_wizz/features/user/domain/usecase/verify_otp_usecase.dart';
import 'package:wisp_wizz/features/user/presentation/utils/validation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser _loginUser;
  final SendCode _sendCode;
  final VerifyOTP _verifyOTP;
  final GetUser _getUser;
  final GetCachedUser _getCachedUser;
  final LogoutUser _logoutUser;
  final UpdateUser _updateUser;
  final CacheUser _cacheUser;
  final InitApplication _initApplication;
  String _verificationId = "";

  AuthBloc(
      {required LoginUser loginUser,
      required SendCode sendCode,
      required VerifyOTP verifyOTP,
      required GetUser getUser,
      required GetCachedUser getCachedUser,
      required LogoutUser logoutUser,
      required UpdateUser updateUser,
      required CacheUser cacheUser,
      required InitApplication initApplication})
      : _loginUser = loginUser,
        _sendCode = sendCode,
        _verifyOTP = verifyOTP,
        _getUser = getUser,
        _getCachedUser = getCachedUser,
        _logoutUser = logoutUser,
        _updateUser = updateUser,
        _cacheUser = cacheUser,
        _initApplication = initApplication,
        super(const AuthLoggedOut()) {
    on<SendCodeEvent>(_onSendCodeEvent);
    on<VerifyOTPEvent>(_onVerifyOTPEvent);
    on<LoginEvent>(_onLogin);
    on<GetUserEvent>(_onGetUser);
    on<GetCachedUserEvent>(_onGetCachedUser);
    on<LogoutEvent>(_onLogout);
    on<UpdateUserEvent>(_onUpdateUser);
    on<InitApplicationEvent>(_onInitApplication);
  }

  Future<void> _onSendCodeEvent(
      SendCodeEvent event, Emitter<AuthState> emit) async {
    emit(const AuthSendingCode());

    final validation = sendCodeValidation(
      event.phoneNumber,
    );

    if (validation.isLeft()) {
      validation.fold((f) => emit(AuthCodeSentFailed(f.message)), (s) => null);
      return;
    }

    final res = await _sendCode(CustomPhoneParam(
      phoneNumber: event.phoneNumber,
    ));

    res.fold(
      (f) => emit(AuthCodeSentFailed(f.message)),
      (s) async {
        if (s.phoneAuthCredential != null) {
          emit(const AuthOTPVerified());
        } else {
          _verificationId = s.verificationId;
          emit(const AuthCodeSent());
        }
      },
    );
  }

  Future<void> _onVerifyOTPEvent(
      VerifyOTPEvent event, Emitter<AuthState> emit) async {
    emit(const AuthVerifyingOTP());
    final validation = verifyOtpValidation(event.otp);
    if (validation.isLeft()) {
      validation.fold(
          (f) => emit(AuthOTPVerificationFailed(f.message)), (s) => null);
      return;
    }
    final res = await _verifyOTP(CustomVerificationParam(
        verificationId: _verificationId, otp: event.otp));
    res.fold((f) => emit(AuthOTPVerificationFailed(f.message)),
        (s) => emit(const AuthOTPVerified()));
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthloggingIn());
    final validation = loginValidation(
      event.name,
      event.phoneNumber,
    );
    if (validation.isLeft()) {
      validation.fold((f) => emit(AuthloginFailed(f.message)), (s) => null);
      return;
    }
    final res = await _loginUser(CustomUserParam(
        name: event.name, phoneNumber: event.phoneNumber, image: event.image));
    if (res.isRight()) {
      final UserModel user = res.asRight();
      final response = await _cacheUser(user);
      response.fold((failure) => emit(AuthloginFailed(failure.message)),
          (sucess) => emit(AuthloggedIn(user: user)));
    } else {
      emit(AuthloginFailed(res.asLeft().message));
    }
  }

  Future<void> _onGetUser(GetUserEvent event, Emitter<AuthState> emit) async {
    emit(const AuthGettingUser());

    final validation = sendCodeValidation(event.phoneNumber);

    if (validation.isLeft()) {
      validation.fold((f) => emit(AuthFailedToGetUser(f.message)), (s) => null);
      return;
    }

    final res = await _getUser(CustomGetUserParam(
      phoneNumber: event.phoneNumber,
    ));

    res.fold(
        (f) => emit(AuthFailedToGetUser(f.message)),
        (s) => {
              if (s != null)
                {emit(AuthUserFound(user: s))}
              else
                {emit(const AuthUserNotFound())}
            });
  }

  void _onGetCachedUser(GetCachedUserEvent event, Emitter<AuthState> emit) {
    emit(const AuthGettingUser());

    final res = _getCachedUser();
    res.fold(
        (f) => emit(AuthFailedToGetUser(f.message)),
        (s) => {
              if (s != null)
                {emit(AuthloggedIn(user: s))}
              else
                {emit(const AuthLoggedOut())}
            });
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoggingout());

    final res = await _logoutUser();

    res.fold((f) => emit(AuthFailedToLogout(f.message)),
        (s) => emit(const AuthLoggedOut()));
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<AuthState> emit) async {
    emit(const AuthUpdatingUser());
    final validation = updateUserVaidation(
      event.id,
    );
    if (validation.isLeft()) {
      validation.fold((f) => emit(AuthloginFailed(f.message)), (s) => null);
      return;
    }

    final res = await _updateUser(
        UpdateUserParam(name: event.name, id: event.id, image: event.image));
    if (res.isRight()) {
      final UserModel user = res.asRight();
      final response = await _cacheUser(user);
      response.fold((failure) => emit(AuthloginFailed(failure.message)),
          (sucess) => emit(AuthloggedIn(user: user)));
    } else {
      emit(AuthloginFailed(res.asLeft().message));
    }
  }

  void _onInitApplication(
      InitApplicationEvent event, Emitter<AuthState> emit) async {
    emit(const AuthInitializingApplication());

    final res = await _initApplication();
    res.fold(
        (f) => emit(AuthInitializationFailed(f.message)),
        (s) => {
              if (s != null)
                {emit(AuthloggedIn(user: s as UserModel))}
              else
                {emit(const AuthLoggedOut())}
            });
  }
}
