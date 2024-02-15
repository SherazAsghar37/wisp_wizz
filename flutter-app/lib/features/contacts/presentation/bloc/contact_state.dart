part of 'contact_bloc.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

final class ContactInitial extends ContactState {}

final class ContactsFetching extends ContactState {}

final class ContactsFetched extends ContactState {
  final List<ContactModel> contacts;
  const ContactsFetched({required this.contacts});
  @override
  List<Object> get props => [contacts];
}

final class ContactsFetchingFailed extends ContactState {
  final String message;
  const ContactsFetchingFailed(this.message);
  @override
  List<Object> get props => [message];
}
