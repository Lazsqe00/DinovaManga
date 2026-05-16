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