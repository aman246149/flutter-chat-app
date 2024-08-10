import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../features/home/logic/chat_logic.dart';

class ChatDatabase {
  static final ChatDatabase _instance = ChatDatabase._internal();
  static Database? _database;

  // Private constructor
  ChatDatabase._internal();

  // Factory constructor to return the same instance
  factory ChatDatabase() {
    print("ChatDatabase factory called");
    return _instance;
  }

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'chatdb.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE groups (
          groupId TEXT NOT NULL PRIMARY KEY,
          name TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE messages (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          message TEXT NOT NULL,
          sender TEXT NOT NULL,
          receiverStatus TEXT NOT NULL,
          senderStatus TEXT NOT NULL,
          receiver TEXT NOT NULL,
          type TEXT NOT NULL,
          timestamp INTEGER NOT NULL,
          groupId TEXT,
          storedInLocalDb INTEGER DEFAULT 0,
          FOREIGN KEY (groupId) REFERENCES groups (groupId) ON DELETE CASCADE
        )
      ''');

      // Create an index on the groupId column in the messages table
      await db.execute('''
      CREATE INDEX idx_groupId ON messages (groupId)
    ''');
    } catch (e) {
      print("Error creating tables: $e");
      rethrow;
    }
  }

  // Example method to insert a group
  Future<int> insertGroup(Map<String, dynamic> group) async {
    try {
      Database db = await database;
      return await db.insert('groups', group);
    } catch (e) {
      print("Error inserting group: $e");
      rethrow;
    }
  }

  // Example method to insert a message
  Future<int> insertMessage(Map<String, dynamic> message) async {
    try {
      Database db = await database;
      int repponse = await db.insert('messages', message);
      return repponse;
    } catch (e) {
      print("Error inserting message: $e");
      rethrow;
    }
  }

  // Example method to retrieve all groups
  Future<List<Map<String, dynamic>>> getGroups() async {
    try {
      Database db = await database;
      return await db.query('groups');
    } catch (e) {
      print("Error retrieving groups: $e");
      rethrow;
    }
  }

  // GET GROUP BY ID
  Future<Map<String, dynamic>> getGroupById(String groupId) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> group =
          await db.query('groups', where: 'groupId = ?', whereArgs: [groupId]);
      if (group.isEmpty) {
        return {};
      }
      return group[0];
    } catch (e) {
      print("Error retrieving group by ID: $e");
      rethrow;
    }
  }

  // Example method to retrieve all messages for a specific group
  Future<List<Map<String, dynamic>>> getMessages(String groupId) async {
    try {
      Database db = await database;
      var result = await db
          .query('messages', where: 'groupId = ?', whereArgs: [groupId]);
      return result;
    } catch (e) {
      print("Error retrieving messages: $e");
      rethrow;
    }
  }

  // Example method to close the database
  Future<void> close() async {
    try {
      Database db = await database;
      await db.close();
    } catch (e) {
      print("Error closing database: $e");
      rethrow;
    }
  }
}

Future<String?> saveFileFromUrl(
    MessageType type, String s3Url, String fileName) async {
  try {
    // Get the correct directory based on the platform (Android/iOS)
    Dio dio = Dio();
    final directory = await getApplicationDocumentsDirectory();
    final localPath = directory.path;

    // Determine the sub-directory based on the MessageType
    String subDir;
    switch (type) {
      case MessageType.image:
        subDir = 'images';
        break;
      case MessageType.video:
        subDir = 'videos';
        break;
      case MessageType.audio:
        subDir = 'audio';
        break;
      case MessageType.file:
        subDir = 'files';
        break;
      default:
        return null; // For text messages, return null or handle accordingly
    }

    // Create the full path for the file
    final fullPath = '$localPath/$subDir/$fileName';

    // Ensure the directory exists
    final directoryToSave = Directory('$localPath/$subDir');
    if (!directoryToSave.existsSync()) {
      directoryToSave.createSync(recursive: true);
    }

    // Download and save the file locally
    await dio.download(s3Url, fullPath);

    // Return the path of the saved file
    return fullPath;
  } catch (e) {
    print('Failed to save file: $e');
    return null;
  }
}
