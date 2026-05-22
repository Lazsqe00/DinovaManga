import 'package:dieu65130478_flutter_app/btn/models/chapter_model.dart';
import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
import 'package:dieu65130478_flutter_app/btn/models/manga_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../helper/dialog.dart';

class BookmarkController extends GetxController{
  var mangas = <MangaModel>[].obs;
  // var chapters = <ChapterModel>[].obs;
  var chapters = <Map<String, dynamic>>[].obs;

  void mangaBookmark(BuildContext context, MangaModel manga){
    int index = mangas.indexWhere((element) => element.slug==manga.slug,);
    if(index!=-1){
      mangas.removeAt(index);
      showSnackBar(context, "Đã xóa khởi bookmart");
    }
    else{
      mangas.insert(0, manga);
      showSnackBar(context, "Đã thêm vào bookmart");
    }
  }

  bool isBookmarkManga(String slug){
    return mangas.any((element) => element.slug==slug,);
  }

  void chapterBookmark(BuildContext context, ChapterModel chapter, MangaDetail detail){
    int index = chapters.indexWhere((element) => element["chapter"].chapterApiData == chapter.chapterApiData,);
    if(index!=-1){
      chapters.removeAt(index);
      showSnackBar(context, "Đã xóa khỏi bookmark");
    }
    else{
      chapters.insert(0, {
        "chapter": chapter,
        "detail": detail
      });
      showSnackBar(context, "Đã thêm vào bookmark");
    }
  }

  bool isBookmartChapter(String chapter){
    return chapters.any((element) => element["chapter"].chapterApiData==chapter,);
  }
}
=======
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../helper/dialog.dart';
import '../models/chapter_model.dart';
import '../models/manga_model.dart';

class BookmarkController extends GetxController {
  var mangas = <MangaModel>[].obs;
  var chapters = <ChapterModel>[].obs;
  final DatabaseHelper _db = DatabaseHelper();

  @override
  void onInit() async {
    super.onInit();
    await _initDatabase();
  }

  Future<void> _initDatabase() async {
    await _db.open();
    final data = await _db.getDSManga();
    mangas.assignAll(data);

    final dataChapters = await _db.getDSChapters();
    chapters.assignAll(dataChapters);
  }

  void mangaBookmark(BuildContext context, MangaModel manga) async {
    bool flag = mangas.any((element) => element.slug == manga.slug);
    if (flag) {
      await _db.deleteManga(manga.slug);
      mangas.removeWhere((e) => e.slug == manga.slug);
      showSnackBar(context, "Đã xóa khỏi yêu thích");
    } else {
      await _db.insertManga(manga);
      mangas.insert(0, manga);
      showSnackBar(context, "Đã thêm vào yêu thích");
    }
  }

  bool isBookmarkedManga(String slug) {
    return mangas.any((element) => element.slug == slug);
  }

  void chapterBookmark(BuildContext context, ChapterModel chapter) async {
    bool flag = chapters.any(
      (element) => element.chapterApiData == chapter.chapterApiData,
    );

    if (flag) {
      await _db.deleteChapter(chapter.chapterApiData);
      chapters.removeWhere(
        (element) => element.chapterApiData == chapter.chapterApiData,
      );
      showSnackBar(context, "Đã xóa chương khỏi danh sách lưu");
    } else {
      await _db.insertChapter(chapter);
      chapters.insert(0, chapter);
      showSnackBar(context, "Đã lưu chương thành công");
    }
  }

  bool isBookmarkedChapter(String chapterApiData) {
    return chapters.any((element) => element.chapterApiData == chapterApiData);
  }

  @override
  void onClose() {
    _db.closeDatabase();
    super.onClose();
  }
}
