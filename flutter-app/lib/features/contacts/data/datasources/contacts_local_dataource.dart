import 'dart:async';
import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager_wrapper.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';
import 'package:wisp_wizz/features/contacts/domain/datasources/i_contacts_local_datasource.dart';

class ContactLocalDatasource extends IContactLocalDatasource {
  final SqfliteManagerWrapper sqfliteManagerWrapper;
  ContactLocalDatasource({required this.sqfliteManagerWrapper});

  @override
  Future<void> saveContacts(List<ContactModel> contacts) async {
    try {
      await sqfliteManagerWrapper.insertMultipleContacts(contacts);
    } catch (e) {
      DebugHelper.printError("sqflite contacts Exception : $e");
      throw const SqfliteDBException("Failed to save Contacts");
    }
  }
}
