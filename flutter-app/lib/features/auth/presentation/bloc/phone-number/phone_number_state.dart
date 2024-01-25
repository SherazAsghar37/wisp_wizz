part of 'phone_number_bloc.dart';

sealed class PhoneNumberState extends Equatable {
  final TextEditingController textEditingController;
  const PhoneNumberState({required this.textEditingController});

  @override
  List<Object> get props => [textEditingController];
}

final class PhoneNumberInitial extends PhoneNumberState {
  const PhoneNumberInitial({required super.textEditingController});
}

final class PhoneNumberUpdated extends PhoneNumberState {
  const PhoneNumberUpdated({required super.textEditingController});
}
