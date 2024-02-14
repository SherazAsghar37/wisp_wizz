part of 'phone_number_bloc.dart';

sealed class PhoneNumberEvent extends Equatable {
  const PhoneNumberEvent();

  @override
  List<Object> get props => [];
}

class InsertEvent extends PhoneNumberEvent {
  final int value;
  const InsertEvent({required this.value});

  @override
  List<Object> get props => [value];
}

class InsertCountryCodeEvent extends PhoneNumberEvent {
  final String countryCode;
  const InsertCountryCodeEvent({required this.countryCode});

  @override
  List<Object> get props => [countryCode];
}

class BackspaceEvent extends PhoneNumberEvent {
  const BackspaceEvent();

  @override
  List<Object> get props => [];
}

class ClearEvent extends PhoneNumberEvent {
  const ClearEvent();

  @override
  List<Object> get props => [];
}
