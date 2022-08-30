import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'newsModel.dart';


class NewsDatabase{
  static final NewsDatabase instance = NewsDatabase.init();

  static Database? _database;

  NewsDatabase.init();

  Future<Database> get database async{
    if (_database != null) return _database!;

    _database = await _initDB('news.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE $tableNews (
    ${NewsFields.id} $idType,
    ${NewsFields.title} $textType,
    ${NewsFields.imageUrl} $textType,
    ${NewsFields.author} $textType
    
    
    )''');
  }

  Future<NewsModel> create(NewsModel news) async{
    final db = await instance.database;

    final id = await db.insert(tableNews, news.toJson());
    return news.copy(id: id);
  }

  Future<NewsModel> read(int id) async{
    final db = await instance.database;

    final maps = await db.query(
      tableNews,
      columns: NewsFields.values,
      where: '${NewsFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty){
      return NewsModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<NewsModel>> readAll() async{
    final db = await instance.database;

    final result = await db.query(tableNews);

    return result.map((json) => NewsModel.fromJson(json)).toList();
  }
  Future close() async{
    final db = await instance.database;
    db.close();
  }
}