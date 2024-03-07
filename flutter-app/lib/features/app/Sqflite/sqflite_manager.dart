import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

class SqfliteManager {
  static late Database db;
  static Future<void> createTables(Database db) async {
    try {
      await db.execute("""create TABLE User(
                      id char(36) primary key default (UUID()),
                      name varchar(100) not null,
                      phoneNumber varchar(15) not null check (LENGTH(phoneNumber)>6) ,
                      image LONGBLOB,
                      status boolean not null default TRUE,
                      lastseen datetime not null  default CURRENT_TIMESTAMP,
                      createdAt datetime not null  default CURRENT_TIMESTAMP,
                      updatedAt datetime not null  default CURRENT_TIMESTAMP)""");
      await db.execute("""CREATE TABLE Chat (
                      id VARCHAR(36) PRIMARY KEY default (UUID()),
                      recipientId VARCHAR(36) DEFAULT (UUID()),
                      senderId VARCHAR(36) DEFAULT (UUID()),
                      unreadMessages int not null default 0,
                      createdAt datetime not null  default CURRENT_TIMESTAMP,
                      updatedAt datetime not null  default CURRENT_TIMESTAMP,
                      CONSTRAINT FK_Chat_User FOREIGN KEY (recipientId) REFERENCES User(id),
                      CONSTRAINT FK_Chat_Sender FOREIGN KEY (senderId) REFERENCES User(id))""");
      await db.execute("""CREATE TABLE Message (
                      id VARCHAR(36) PRIMARY KEY default (UUID()),
                      chatId VARCHAR(36) DEFAULT (UUID()),
                      message LONGTEXT not null,
                      messageStatus TEXT CHECK(messageStatus IN ('Read', 'Sent', 'Unread', 'Seen')) DEFAULT 'Sent',
                      repliedToId  VARCHAR(36),
                      createdAt datetime not null  default CURRENT_TIMESTAMP,
                      updatedAt datetime not null  default CURRENT_TIMESTAMP,
                      CONSTRAINT FK_Chat_Message FOREIGN KEY (chatId) REFERENCES Chat(id),
                      CONSTRAINT FK_Replied_Message FOREIGN KEY (repliedToId) REFERENCES Message(id))""");
    } catch (e) {
      throw SqfliteDBException(e.toString());
    }
  }

  static Future<void> dropdb() async {
    try {
      await sql.deleteDatabase(dbName);
    } catch (e) {
      DebugHelper.printError("dropping db : $e");
    }
  }

  static Future<Database> getDB() async {
    var databasesPath = await getDatabasesPath();
    DebugHelper.printError(databasesPath.toString());
// String path = join(databasesPath, 'demo.db');
    try {
      return db = await sql.openDatabase(
        dbName,
        version: 1,
        onCreate: (db, version) async => await createTables(db),
      );
    } catch (e) {
      throw SqfliteDBException(e.toString());
    }
  }

  static Future<int> createUser(
      {required String id,
      required String name,
      required String phoneNumber,
      required Uint8List image}) async {
    try {
      final Database db = await getDB();
      final data = {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "image": image
      };
      return await db.insert("User", data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw SqfliteDBException(e.toString());
    }
  }

  static Future<void> saveMessage({
    required String senderId,
    required String recipientId,
    required String message,
  }) async {
    try {
      final db = await getDB();
      final result = await db.query('Chat',
          where: 'recipientId = ?',
          whereArgs: [recipientId],
          columns: ['id'] // Replace with your actual value for id
          );
      DebugHelper.printWarning(result.toString());
    } catch (e) {}
  }

  static Future<String> fetchChat(String recipientId, String senderId) async {
    try {
      final result = await db.query('Chat',
          where: 'recipientId = ? and senderId = ?',
          whereArgs: [recipientId, senderId],
          columns: ['id']);
      DebugHelper.printWarning(result.toString());
      return "asd";
    } catch (e) {
      throw SqfliteDBException(e.toString());
    }
  }

  static Future<void> insertMultipleContacts(List<ContactModel> data) async {
    try {
      final db = await getDB();
      final token = RootIsolateToken.instance!;
      final port = ReceivePort("contacts");
      await Isolate.spawn(_isolateEntry, [db, data, port.sendPort, token]);
      await port.first;
    } catch (e) {
      SqfliteDBException(e.toString());
    }
  }

  static void _isolateEntry(List args) async {
    try {
      BackgroundIsolateBinaryMessenger.ensureInitialized(args[3]);
      final db = args[0] as Database;
      final data = args[1] as List<ContactModel>;
      final batch = db.batch();
      for (final item in data) {
        batch.insert(
            'User',
            {
              "id": item.id,
              "name": item.name,
              "phoneNumber": item.phoneNumber,
              "image": item.image
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit();
      args[2].send("completed");
    } catch (e) {
      rethrow;
    }
  }
}
