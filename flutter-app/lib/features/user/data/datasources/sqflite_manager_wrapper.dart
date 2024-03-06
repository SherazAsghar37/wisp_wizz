import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:wisp_wizz/features/app/Sqflite/sqflite_manager.dart';

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
}
