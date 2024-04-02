// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wisp_wizz/features/app/config/extensions.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';
import 'package:wisp_wizz/features/contacts/domain/usecases/fetch_contacts_usecase.dart';
import 'package:wisp_wizz/features/contacts/domain/usecases/fetch_server_contacts.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final FetchContactsUsecase _fetchContactsUsecase;
  final FetchServerContactsUsecase _fetchServerContactsUsecase;
  ContactBloc(
      {required FetchContactsUsecase fetchContactsUsecase,
      required FetchServerContactsUsecase fetchServerContactsUsecase})
      : _fetchContactsUsecase = fetchContactsUsecase,
        _fetchServerContactsUsecase = fetchServerContactsUsecase,
        super(ContactInitial()) {
    on<ContactFetchEvent>(_onContactFetch);
  }
  Future<void> _onContactFetch(
      ContactFetchEvent event, Emitter<ContactState> emit) async {
    emit(ContactsFetching());
    final response = await _fetchContactsUsecase();
    response.fold((f) => emit(ContactsFetchingFailed(f.message)), (s) {
      emit(LocalContactsFetched(contacts: s));
    });

    final res = await _fetchServerContactsUsecase();
    if (res.isRight()) {
      final data = res.asRight();
      emit(ContactsFetched(contacts: data));
    }
  }
}
