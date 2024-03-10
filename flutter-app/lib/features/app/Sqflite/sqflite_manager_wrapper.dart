import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

class SqfliteManagerWrapper {
  const SqfliteManagerWrapper();
  Future<int> createUser(
      {required String id,
      required String name,
      required String phoneNumber,
      required Uint8List image}) {
    return SqfliteManager.createUser(
        id: id, name: name, phoneNumber: phoneNumber, image: image);
  }

  Future<Database> getDB() {
    return SqfliteManager.getDB();
  }

  Future<void> saveMessage({
    required String recipientId,
    required String senderId,
    required String message,
  }) {
    return SqfliteManager.saveMessage(
        recipientId: recipientId, message: message, senderId: senderId);
  }

  Future<void> insertMultipleContacts(List<ContactModel> data) async {
    return SqfliteManager.insertMultipleContacts(data);
  }

  Future<MapData> fetchChat(String recipientId, String senderId) async {
    return SqfliteManager.fetchChat(recipientId, senderId);
  }
}
