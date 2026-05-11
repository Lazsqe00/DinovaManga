import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Database/database_helper.dart';
import '../helper/dialog.dart';
import '../models/manga_model.dart';

class BookmarkController extends GetxController {
  var bookmarks = <MangaModel>[].obs;
  final DatabaseHelper _db = DatabaseHelper();

  @override
  void onInit() async {
    super.onInit();
    await _initDatabase();
  }

  Future<void> _initDatabase() async {
    await _db.open();
    final data = await _db.getDS();
    bookmarks.assignAll(data);
  }

  void bookmark(BuildContext context, MangaModel manga) async {
    bool flag = bookmarks.any((element) => element.slug == manga.slug);
    if (flag) {
      await _db.delete(manga.slug);
      bookmarks.removeWhere((e) => e.slug == manga.slug);
      showSnackBar(context, "Đã xóa khỏi yêu thích");
    } else {
      await _db.insert(manga);
      bookmarks.add(manga);
      showSnackBar(context, "Đã thêm vào yêu thích");
    }
  }

  bool isBookmarked(String slug) {
    return bookmarks.any((element) => element.slug == slug);
  }

  @override
  void onClose() {
    _db.closeDatabase();
    super.onClose();
  }
}
