import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

abstract class IContactReposiotry {
  ResultFuture<List<ContactModel>> fetchContacts();
}
