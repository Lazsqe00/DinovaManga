import 'package:dieu65130478_flutter_app/btn/controller/bookmark_controller.dart';
import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
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
                  final chapter = detail.chapters[index];
                  return Card(
                    child: ListTile(
                      onTap: () {},
                      title: Text('Chương ${chapter.chapterName}'),

                      trailing: Obx(() {
                        bool flag = controllerBookmark.isBookmarkedChapter(
                          chapter.chapterApiData,
                        );
                        return IconButton(
                          icon: Icon(
                            flag ? Icons.star : Icons.star_border,
                            color: flag ? Colors.yellow[700] : Colors.grey,
                          ),
                          onPressed: () {
                            controllerBookmark.chapterBookmark(
                              context,
                              chapter,
                            );
                          },
                        );
                      }),
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
