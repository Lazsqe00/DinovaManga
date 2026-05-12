import 'package:dieu65130478_flutter_app/btn/controller/manga_controller.dart';
import 'package:dieu65130478_flutter_app/btn/models/chapterAPI_model.dart';
import 'package:dieu65130478_flutter_app/btn/models/chapter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../controller/bookmark_controller.dart';
import '../helper/dialog.dart';

Widget buildChapterList(BuildContext context) {
  final controllerBookmark = Get.find<BookmarkController>();
  final controllerManga = Get.find<MangaController>();
  return Obx(() {
    if (controllerBookmark.chapters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "Bạn chưa lưu chương truyện nào.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsetsGeometry.all(10),
      itemCount: controllerBookmark.chapters.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final chapter = controllerBookmark.chapters[index];

        return Slidable(
          // Specify a key if the Slidable is dismissible.
          key: const ValueKey(0),
          // The end action pane is the one at the right or the bottom side.
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _xoa(context, chapter),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Xóa',
              ),
            ],
          ),
          // The child of the Slidable is what the user sees when the
          // component is not dragged.
          child: FutureBuilder(
            future: controllerManga.fetchChapterModel(chapter.chapterApiData),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("Lỗi rầu: ${snapshot.error.toString()}");
                return Center(
                  child: Text("Lỗi rầu: ${snapshot.error.toString()}"),
                );
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              ChapterDataAPI chapterAPI = snapshot.data!;
              return Card(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsetsGeometry.fromLTRB(5, 10, 2, 5),
                      height: 140,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "${chapterAPI.domainCdn}/${chapterAPI.chapterPath}/${chapterAPI.images[2]}",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "Chapter ${chapter.chapterName}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                          ),
                          SizedBox(height: 8),
                          Text(
                            chapter.filename,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsetsGeometry.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Đã lưu",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  });
}

void _xoa(BuildContext context, ChapterModel chapter) async {
  final controllerBookmark = Get.find<BookmarkController>();
  String? confirm = await showConfirmDialog(
    context!,
    "Bạn có muốn xóa ${chapter.filename!}",
  );
  if (confirm == "ok") {
    controllerBookmark.chapterBookmark(context, chapter);
  }
}
