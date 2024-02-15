import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

abstract class IContactDatasource {
  Future<List<ContactModel>> readContacts();
}
