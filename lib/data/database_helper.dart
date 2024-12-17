import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:game_hub/model/Comment.dart';
import 'package:game_hub/model/Writing.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('game.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE article_profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        detail TEXT NOT NULL,
        summary TEXT NOT NULL,
        image TEXT NOT NULL,
        link TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        writingId INTEGER NOT NULL,
        content TEXT NOT NULL,
        FOREIGN KEY (writingId) REFERENCES article_profiles (id) ON DELETE CASCADE
      );
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE comments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          writingId INTEGER NOT NULL,
          content TEXT NOT NULL,
          FOREIGN KEY (writingId) REFERENCES article_profiles (id) ON DELETE CASCADE
        );
      ''');
    }
  }

  // getTableNames 함수 추가
  Future<List<String>> getTableNames() async {
    final db = await instance.database;
    final result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type = 'table'");
    return result.map((row) => row['name'] as String).toList();
  }

  Future<void> insertArticle(Map<String, dynamic> article) async {
    final db = await instance.database;
    await db.insert('article_profiles', article);
  }

  Future<List<Map<String, dynamic>>> getAllArticles() async {
    final db = await instance.database;
    return await db.query('article_profiles');
  }

  Future<int> deleteArticle(int id) async {
    final db = await instance.database;
    return await db.delete(
      'article_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertComment(Comment comment) async {
    final db = await instance.database;
    await db.insert('comments', {
      'writingId': comment.writingId,
      'content': comment.content,
    });
  }

  Future<List<Comment>> getCommentsForWriting(int writingId) async {
    final db = await instance.database;
    final result = await db.query(
      'comments',
      where: 'writingId = ?',
      whereArgs: [writingId],
    );
    return result.map((map) => Comment.fromMap(map)).toList();
  }
}
