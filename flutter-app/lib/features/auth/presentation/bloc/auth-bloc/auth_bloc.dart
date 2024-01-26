import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/get_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/send_code_usecase.dart';
import 'package:wisp_wizz/features/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:wisp_wizz/features/auth/presentation/utils/validation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser _loginUser;
  final SendCode _sendCode;
  final VerifyOTP _verifyOTP;
  final GetUser _getUser;
  String _verificationId = "";

  AuthBloc(
      {required LoginUser loginUser,
      required SendCode sendCode,
      required VerifyOTP verifyOTP,
      required GetUser getUser})
      : _loginUser = loginUser,
        _sendCode = sendCode,
        _verifyOTP = verifyOTP,
        _getUser = getUser,
        super(const AuthInitial()) {
    on<SendCodeEvent>(_onSendCodeEvent);
    on<VerifyOTPEvent>(_onVerifyOTPEvent);
    on<LoginEvent>(_onLoginEvent);
    on<GetUserEvent>(_onGetUser);
  }

  Future<void> _onSendCodeEvent(
      SendCodeEvent event, Emitter<AuthState> emit) async {
    emit(const AuthSendingCode());

    final validation = sendCodeValidation(event.phoneNumber, event.countryCode);

    if (validation.isLeft()) {
      validation.fold((f) => emit(AuthCodeSentFailed(f.message)), (s) => null);
      return;
    }

    final res = await _sendCode(CustomPhoneParam(
      phoneNumber: event.phoneNumber,
      countryCode: event.countryCode,
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

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthloggingIn());
    final validation = loginValidation(
        event.countryCode, event.name, event.phoneNumber, event.image);
    if (validation.isLeft()) {
      validation.fold((f) => emit(AuthloginFailed(f.message)), (s) => null);
      return;
    }
    final res = await _loginUser(CustomUserParam(
        countryCode: event.countryCode,
        name: event.name,
        phoneNumber: event.phoneNumber,
        image: event.image));
    res.fold((f) => emit(AuthloginFailed(f.message)),
        (s) => emit(AuthloggedIn(user: s)));
  }

  Future<void> _onGetUser(GetUserEvent event, Emitter<AuthState> emit) async {
    emit(const AuthGettingUser());

    final validation = sendCodeValidation(event.phoneNumber, event.countryCode);

    if (validation.isLeft()) {
      validation.fold((f) => emit(AuthFailedToGetUser(f.message)), (s) => null);
      return;
    }
    final phoneNumber = int.parse(event.phoneNumber);

    final res = await _getUser(CustomGetUserParam(
        phoneNumber: phoneNumber, countryCode: event.countryCode));

    res.fold(
        (f) => emit(AuthFailedToGetUser(f.message)),
        (s) => {
              if (s != null)
                {emit(AuthUserFound(user: s))}
              else
                {emit(const AuthUserNotFound())}
            });
  }
}
