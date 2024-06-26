import 'package:wisp_wizz/features/app/usecases/usecase.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/contacts/domain/repository/i_contacts_repository.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

class FetchServerContactsUsecase extends UsecaseWithoutParam {
  final IContactReposiotry contactReposiotry;
  const FetchServerContactsUsecase({required this.contactReposiotry});
  @override
  ResultFuture<List<ContactModel>> call() async =>
      contactReposiotry.fetchServerContacts();
}
