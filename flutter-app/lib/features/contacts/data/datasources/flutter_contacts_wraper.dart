import 'package:flutter_contacts/flutter_contacts.dart';

class FlutterContactsWrapper {
  Future<List<Contact>> getContacts() async {
    return await FlutterContacts.getContacts(
      withProperties: true,
    );
  }
}
