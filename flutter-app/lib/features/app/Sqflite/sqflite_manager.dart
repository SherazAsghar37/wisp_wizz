import 'dart:typed_data';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';

class SqfliteManager {
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
                      unreadMessages int not null default 0,
                      createdAt datetime not null  default CURRENT_TIMESTAMP,
                      updatedAt datetime not null  default CURRENT_TIMESTAMP,
                      CONSTRAINT FK_Chat_User FOREIGN KEY (recipientId) REFERENCES User(id))""");
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

  static Future<Database> getDB() async {
//     var databasesPath = await getDatabasesPath();
// String path = join(databasesPath, 'demo.db');
    try {
      return await sql.openDatabase(
        "dbName",
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
}
