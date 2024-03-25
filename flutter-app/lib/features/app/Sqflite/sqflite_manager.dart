import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:wisp_wizz/features/app/config/extensions.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/helper/debug_helper.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/contacts/data/models/contact_model.dart';

class SqfliteManager {
  static late Database db;
  static Future<void> createTables(Database db) async {
    try {
      await db.execute("""create TABLE User(
                      id char(36) primary key not null,
                      name varchar(100) not null,
                      phoneNumber varchar(15) not null check (LENGTH(phoneNumber)>6) ,
                      image LONGBLOB,
                      status boolean not null default TRUE,
                      lastSeen datetime not null  default CURRENT_TIMESTAMP,
                      createdAt datetime not null  default CURRENT_TIMESTAMP,
                      updatedAt datetime not null  default CURRENT_TIMESTAMP)""");
      await db.execute("""CREATE TABLE Chat (
                      chatId VARCHAR(36) PRIMARY KEY not null,
                      recipientId VARCHAR(36) NOT NULL,
                      senderId VARCHAR(36) NOT NULL,
                      unreadMessages int not null default 0,
                      createdAt datetime not null  default CURRENT_TIMESTAMP,
                      updatedAt datetime not null  default CURRENT_TIMESTAMP,
                      CONSTRAINT FK_Chat_User FOREIGN KEY (recipientId) REFERENCES User(id),
                      CONSTRAINT FK_Chat_Sender FOREIGN KEY (senderId) REFERENCES User(id))""");
      await db.execute("""CREATE TABLE Message (
                      messageId VARCHAR(36) PRIMARY KEY NOT NULL,
                      chatId VARCHAR(36) NOT NULL,
                      recipientId VARCHAR(36) NOT NULL,
                      senderId VARCHAR(36)  NOT NULL,
                      message LONGTEXT not null,
                      messageStatus TEXT CHECK(messageStatus IN ('Sending', 'Sent', 'Delivered', 'Seen')) DEFAULT 'Sent',
                      repliedToId  VARCHAR(36),
                      createdAt datetime not null  default CURRENT_TIMESTAMP,
                      updatedAt datetime not null  default CURRENT_TIMESTAMP,
                      CONSTRAINT FK_Chat_Message FOREIGN KEY (chatId) REFERENCES Chat(chatId),
                      CONSTRAINT FK_Replied_Message FOREIGN KEY (repliedToId) REFERENCES Message(messageId),
                      CONSTRAINT FK_Message_Recipient FOREIGN KEY (recipientId) REFERENCES User(id),
                      CONSTRAINT FK_Message_Sender FOREIGN KEY (senderId) REFERENCES User(id)
                      )""");
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
      required String image}) async {
    try {
      final Database db = await getDB();
      final data = {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "image": image,
        "createdAt": DateTime.now().toSqfliteFormat(),
        "updatedAt": DateTime.now().toSqfliteFormat(),
      };
      return await db.insert("User", data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw SqfliteDBException(e.toString());
    }
  }

  // static Future<void> saveMessage({
  //   required String senderId,
  //   required String recipientId,
  //   required String message,
  // }) async {
  //   try {
  //     final db = await getDB();
  //     final result = await db.query('Chat',
  //         where: 'recipientId = ?',
  //         whereArgs: [recipientId],
  //         columns: ['id'] // Replace with your actual value for id
  //         );
  //     DebugHelper.printWarning(result.toString());
  //   } catch (e) {}
  // }

  static Future<MapData> fetchChat(String recipientId, String senderId) async {
    try {
      List<Map<String, dynamic>> chatAndSenderData =
          await db.rawQuery("""SELECT * FROM Chat as c 
          INNER JOIN User as u ON c.recipientId = u.id 
          WHERE c.senderId ='$senderId' and c.recipientId = '$recipientId'""");
      List<Map<String, dynamic>> messages = chatAndSenderData.isNotEmpty
          ? await db.rawQuery("""SELECT * FROM Message 
          WHERE chatId ='${chatAndSenderData[0]["chatId"]}'""")
          : [];

      if (chatAndSenderData.isEmpty) {
        var uuid = const Uuid();
        await db.insert(
            "Chat",
            {
              "recipientId": recipientId,
              "senderId": senderId,
              "chatId": uuid.v6(),
              "createdAt": DateTime.now().toSqfliteFormat(),
              "updatedAt": DateTime.now().toSqfliteFormat(),
            },
            conflictAlgorithm: ConflictAlgorithm.abort);
        chatAndSenderData = await db.rawQuery("""SELECT * FROM Chat as c 
          INNER JOIN User as u ON c.recipientId = u.id 
          WHERE c.senderId ='$senderId' and c.recipientId = '$recipientId'""");
        messages = await db.rawQuery("""
          SELECT * FROM Message 
          where chatId = ?
         """, [chatAndSenderData[0]["chatId"]]);
      }
      final Map<String, dynamic> data = {
        "messages": messages,
        ...chatAndSenderData[0],
      };
      DebugHelper.printWarning(data.toString());
      return data;
    } catch (e) {
      throw SqfliteDBException(e.toString());
    }
  }

  static Future<List<MapData>> fetchMessages(String chatId) async {
    try {
      List<Map<String, dynamic>> messages = await db.rawQuery("""
          SELECT m.*,(Select ms.message from Message as ms where ms.messageId = m.repliedToId) FROM Message as m 
          LEFT JOIN Chat as c on c.chatId = m.chatId
          where m.chatId = ?
         """, [chatId]);
      await db.rawQuery("""
          UPDATE Chat SET unreadMessages = 0
          where chatId = ?
         """, [chatId]);

      return messages;
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
              "image": base64Encode(item.image),
              "createdAt": DateTime.now().toSqfliteFormat(),
              "updatedAt": DateTime.now().toSqfliteFormat(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit();
      args[2].send("completed");
    } catch (e) {
      rethrow;
    }
  }

  static Future<MapData> insertMessage(MapData data, bool isChatClosed) async {
    try {
      var uuid = const Uuid();
      final id = uuid.v6();
      final newdata = {
        ...data,
        "messageId": data["messageId"] ?? id,
        "updatedAt": data["createdAt"]
      };
      // DebugHelper.printWarning(newdata.toString());
      await db.insert(
        "Message",
        newdata,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      if (isChatClosed) {
        DebugHelper.printError("here");
        await db.rawQuery("""
      UPDATE Chat SET unreadMessages = unreadMessages +1  WHERE chatId = ? 
      """, [data["chatId"]]);
      }
      return newdata;
    } catch (e) {
      throw SqfliteDBException(e.toString());
    }
  }

  static Future<MapData> fetchChats(String userId, int currentPage) async {
    try {
      // final data = await db.rawQuery('''
      // SELECT c.*, m.messageId, m.message, m.messageStatus, m.updatedAt AS sentAt,u.*
      // FROM Chat AS c
      // INNER JOIN User as u on c.recipientId = u.id
      // LEFT JOIN Message AS m ON c.chatId = m.chatId
      // AND m.messageId = (SELECT m2.messageId FROM Message AS m2 WHERE m2.chatId = c.chatId ORDER BY createdAt desc limit 1)
      // WHERE c.senderId = ?
      // ORDER BY m.updatedAt desc
      // LIMIT ? OFFSET ?
      // ''', [userId, chatsLoadAtEachTime, currentPage * chatsLoadAtEachTime]);

      List<MapData> data = await db.rawQuery('''
      SELECT c.*,u.*
      FROM Chat AS c
      INNER JOIN User as u on c.recipientId = u.id
      LEFT JOIN Message AS m ON c.chatId = m.chatId
      WHERE c.senderId = ?
      AND m.messageId = (SELECT m2.messageId FROM Message AS m2 WHERE m2.chatId = c.chatId ORDER BY createdAt desc limit 1)
      ORDER BY m.updatedAt desc
      LIMIT ? OFFSET ?
      ''', [userId, chatsLoadAtEachTime, currentPage * chatsLoadAtEachTime]);
      List<MapData> newData = [];
      for (var i = 0; i < data.length; i++) {
        final messagesData = await db.rawQuery(
            "Select * from Message WHERE chatId = ?", [data[i]["chatId"]]);
        newData.add({...data[i], "messages": messagesData});
        // data[i]["messages"] = messagesData;
        // data[i] = {...data[i], "messages": messagesData};
      }

      final totalUnreadMessages = await db.rawQuery('''
      SELECT SUM(unreadMessages) as totalUnreadMessages
      FROM Chat where senderId = '$userId'
      ''');
      log(newData.toString());

      return {
        "data": newData,
        "totalUnreadMessages": totalUnreadMessages[0]["totalUnreadMessages"],
      };
    } catch (e) {
      throw SqfliteDBException(e.toString());
    }
  }

  static Future<void> trunciateMessages() async {
    try {
      await db.rawQuery(
        '''DELETE FROM Message''',
      );
    } catch (e) {
      throw SqfliteDBException(e.toString());
    }
  }
}
