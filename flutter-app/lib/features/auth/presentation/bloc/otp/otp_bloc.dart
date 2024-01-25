import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(const OtpInitial(otp: "", focusFieldNumber: 0)) {
    on<InsertEvent>(onInsertEvent);
    on<BackspaceEvent>(onBackSpace);
    on<ClearEvent>(onClear);
  }

  FutureOr<void> onInsertEvent(
      InsertEvent event, Emitter<OtpState> emit) async {
    String otp = state.otp;
    int focusFieldNumber = state.focusFieldNumber;
    if (focusFieldNumber <= (verificationCodeLength - 1)) {
      otp = "$otp${event.value}";
      focusFieldNumber++;
    }
    emit(OtpUpdated(otp: otp, focusFieldNumber: focusFieldNumber));
  }

  FutureOr<void> onBackSpace(BackspaceEvent event, Emitter<OtpState> emit) {
    String otp = state.otp;
    int focusFieldNumber = state.focusFieldNumber;
    if (otp.isNotEmpty) {
      otp = otp.substring(0, otp.length - 1);
      focusFieldNumber--;
    }
    emit(OtpUpdated(otp: otp, focusFieldNumber: focusFieldNumber));
  }

  void onClear(ClearEvent event, Emitter<OtpState> emit) {
    emit(const OtpUpdated(otp: "", focusFieldNumber: 0));
  }
}
