import 'package:sqflite/sqflite.dart';

import '../models/chapter_model.dart';
import '../models/manga_model.dart';

class DatabaseHelper {
  Database? database;
  String? _path;
  final String tableManga = 'MangaBookmarks';
  final String tableChapter = 'ChapterBookmarks';

  Future<String?> _getDatabasePath(String databaseName) async {
    String p = await getDatabasesPath();
    String path = "$p/$databaseName";
    _path = path;
    return path;
  }

  Future<Database?> open() async {
    String? path = await _getDatabasePath('bookmarks.db');
    database = await openDatabase(
      path!,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tableManga (slug TEXT PRIMARY KEY, title TEXT, thumbUrl '
          'TEXT)',
        );
        await db.execute(
          'CREATE TABLE $tableChapter (chapterApiData TEXT PRIMARY KEY, '
          'filename TEXT, chapterName TEXT, chapterTitle TEXT, slug TEXT)',
        );
      },
    );
    return database;
  }

  Future<void> insertManga(MangaModel manga) async {
    await database!.transaction((Transaction txn) async {
      await txn.rawInsert(
        'INSERT INTO $tableManga(slug, title, thumbUrl) VALUES(?, ?, ?)',
        [manga.slug, manga.title, manga.thumbUrl],
      );
    });
  }

  Future<int> deleteManga(String slug) async {
    int count = await database!.rawDelete(
      "DELETE FROM $tableManga WHERE slug = ?",
      [slug],
    );
    return count;
  }

  Future<List<MangaModel>> getDSManga() async {
    List<Map<String, dynamic>> list = await database!.rawQuery(
      "SELECT * FROM $tableManga",
    );
    return list.map((json) => MangaModel.fromMap(json)).toList();
  }

  Future<void> insertChapter(ChapterModel chapter) async {
    await database!.transaction((Transaction txn) async {
      await txn.rawInsert(
        'INSERT INTO $tableChapter(chapterApiData, filename, chapterName, chapterTitle, slug) VALUES(?, ?, ?, ?, ?)',
        [
          chapter.chapterApiData,
          chapter.filename,
          chapter.chapterName,
          chapter.chapterTitle,
          chapter.slug,
        ],
      );
    });
  }

  Future<int> deleteChapter(String chapterApiData) async {
    int count = await database!.rawDelete(
      "DELETE FROM $tableChapter WHERE chapterApiData = ?",
      [chapterApiData],
    );
    return count;
  }

  Future<List<ChapterModel>> getDSChapters() async {
    List<Map<String, dynamic>> list = await database!.rawQuery(
      "SELECT * FROM $tableChapter",
    );
    return list.map((json) => ChapterModel.fromMap(json)).toList();
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
