part of 'phone_number_bloc.dart';

sealed class PhoneNumberState extends Equatable {
  final TextEditingController textEditingController;
  final String countryCode;
  const PhoneNumberState(
      {required this.textEditingController, required this.countryCode});

  @override
  List<Object> get props => [textEditingController, countryCode];
}

final class PhoneNumberInitial extends PhoneNumberState {
  const PhoneNumberInitial(
      {required super.textEditingController, required super.countryCode});
}

final class PhoneNumberUpdated extends PhoneNumberState {
  const PhoneNumberUpdated(
      {required super.textEditingController, required super.countryCode});
}
