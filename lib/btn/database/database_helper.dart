import 'package:sqflite/sqflite.dart';

import '../models/manga_model.dart';

class DatabaseHelper {
  Database? database;
  String? _path;
  final String tableName = 'bookmarks';

  Future<String?> _getDatabasePath(String databaseName) async {
    String p = await getDatabasesPath();
    String path = "$p/$databaseName";
    _path = path;
    return path;
  }

  Future<Database?> open() async {
    String? path = await _getDatabasePath('manga_demo.db');
    database = await openDatabase(
      path!,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tableName (slug TEXT PRIMARY KEY, title TEXT, thumbUrl TEXT)',
        );
      },
    );
    return database;
  }

  Future<void> insert(MangaModel manga) async {
    await database!.transaction((Transaction txn) async {
      await txn.rawInsert(
        'INSERT INTO $tableName(slug, title, thumbUrl) VALUES(?, ?, ?)',
        [manga.slug, manga.title, manga.thumbUrl],
      );
    });
  }

  Future<int> delete(String slug) async {
    int count = await database!.rawDelete(
      "DELETE FROM $tableName WHERE slug = ?",
      [slug],
    );
    return count;
  }

  Future<List<MangaModel>> getDS() async {
    List<Map<String, dynamic>> list = await database!.rawQuery(
      "SELECT * FROM $tableName",
    );
    return list.map((json) => MangaModel.fromMap(json)).toList();
  }

  Future<void> closeDatabase() async {
    if (database != null) {
      await database!.close();
    }
  }

  void deleteDB() {
    if (_path != null) {
      deleteDatabase(_path!);
    }
  }
}
