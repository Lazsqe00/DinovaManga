import 'package:dieu65130478_flutter_app/btn/controller/bookmark_controller.dart';
import 'package:dieu65130478_flutter_app/btn/models/chapter_model.dart';
import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_doc_truyen.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_tim_kiem_chuong.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageDanhSachChuong extends StatelessWidget {
  PageDanhSachChuong({super.key, required this.detail});

  MangaDetail detail;
  final controllerBookmark = Get.find<BookmarkController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách chương truyện'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TimKiemChuong(detail: detail),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Tổng số chương: ${detail.chapters.length}',
              style: TextStyle(fontSize: 15),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: detail.chapters.length,
                itemBuilder: (context, index) {
                  ChapterModel chapter = detail.chapters[index];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          () => PageDocTruyen(
                            chuong: chapter.chapterName,
                            chapter: chapter,
                            detail: detail,
                            currentIndex: index,
                          ),
                        );
                      },
                      title: Text('Chương ${chapter.chapterName}'),
                      trailing: Obx(
                        () => IconButton(
                          onPressed: () {
                            controllerBookmark.chapterBookmark(
                              context,
                              chapter,
                            );
                          },
                          icon:
                              controllerBookmark.isBookmarkedChapter(
                                chapter.chapterApiData,
                              )
                              ? Icon(Icons.star)
                              : Icon(Icons.star_border),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
