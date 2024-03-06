import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/contacts/data/datasources/flutter_contacts_wraper.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';
import 'package:wisp_wizz/features/contacts/domain/datasources/i_contacts_data_source.dart';

class ContactDatasource extends IContactDatasource {
  final FlutterContactsWrapper flutterContactsWrapper;
  final Dio dio;
  ContactDatasource({required this.flutterContactsWrapper, required this.dio});

  @override
  Future<List<ContactModel>> readContacts() async {
    try {
      List<ContactModel> data = [];
      List<Contact> contacts = await flutterContactsWrapper.getContacts();
      final formattedContacts = contacts.expand((contact) {
        return contact.phones.map((phone) {
          return phone.number.startsWith("+92")
              ? phone.number.replaceAll(" ", "")
              : "+92${phone.number.substring(1)}".replaceAll(" ", "");
        });
      }).toList();
      final response =
          await dio.post(getContactsUrl, data: {"contacts": formattedContacts});
      if (response.statusCode == 200) {
        final List<MapData> dbContacts =
            List<MapData>.from(jsonDecode(response.data)["users"]);
        data = dbContacts.map((e) {
          return ContactModel.fromMap(e);
        }).toList();
      }

      return data;
    } catch (e) {
      DebugHelper.printError("Contacts Exception : $e");
      throw const ContactException(message: "Failed to Load Contacts");
    }
  }
}
