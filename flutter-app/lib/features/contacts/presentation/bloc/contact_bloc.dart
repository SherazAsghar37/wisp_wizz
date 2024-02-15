// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';
import 'package:wisp_wizz/features/contacts/domain/usecases/fetch_contacts.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final FetchContacts _fetchContacts;
  ContactBloc({required FetchContacts fetchContacts})
      : _fetchContacts = fetchContacts,
        super(ContactInitial()) {
    on<ContactFetchEvent>(_onContactFetch);
  }
  Future<void> _onContactFetch(
      ContactFetchEvent event, Emitter<ContactState> emit) async {
    emit(ContactsFetching());
    final response = await _fetchContacts();
    response.fold((f) => emit(ContactsFetchingFailed(f.message)),
        (s) => emit(ContactsFetched(contacts: s)));
  }
}
