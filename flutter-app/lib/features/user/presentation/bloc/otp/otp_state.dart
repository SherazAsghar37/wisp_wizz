part of 'otp_bloc.dart';

sealed class OtpState extends Equatable {
  final String otp;
  final int focusFieldNumber;
  const OtpState({required this.otp, required this.focusFieldNumber});

  @override
  List<Object> get props => [otp, focusFieldNumber];
}

final class OtpInitial extends OtpState {
  const OtpInitial({required super.otp, required super.focusFieldNumber});
  @override
  List<Object> get props => [otp, focusFieldNumber];
}

final class OtpUpdated extends OtpState {
  const OtpUpdated({required super.otp, required super.focusFieldNumber});
  @override
  List<Object> get props => [otp, focusFieldNumber];
}
