import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

abstract class IContactLocalDatasource {
  Future<void> saveContacts(List<ContactModel> contacts);
  Future<List<ContactModel>> fetchContacts();
}
