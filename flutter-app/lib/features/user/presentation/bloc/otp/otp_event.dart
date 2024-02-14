part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class InsertEvent extends OtpEvent {
  final int value;
  const InsertEvent({required this.value});

  @override
  List<Object> get props => [value];
}

class BackspaceEvent extends OtpEvent {
  const BackspaceEvent();

  @override
  List<Object> get props => [];
}

class ClearEvent extends OtpEvent {
  const ClearEvent();

  @override
  List<Object> get props => [];
}
