import 'package:dieu65130478_flutter_app/btn/controller/bookmark_controller.dart';
import 'package:dieu65130478_flutter_app/btn/controller/manga_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../models/managa_detail.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';
import '../page/page_chitiet_testmau.dart';

Widget buildMangaList(BuildContext context) {
  final controller_bookmark = Get.find<BookmarkController>();
  final controller_manga = Get.find<MangaController>();
  return Obx(() {
    if (controller_bookmark.mangas.isEmpty) {
      return Center(
        child: Text(
          "Bạn chưa đánh dấu manga yêu thích.",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: ListView.builder(
        itemBuilder: (context, index) {
          MangaModel manga = controller_bookmark.mangas[index];
          return Slidable(
            // Specify a key if the Slidable is dismissible.
            key: const ValueKey(0),
            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    controller_bookmark.mangaBookmark(context, manga);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Xóa',
                ),
              ],
            ),
            // The child of the Slidable is what the user sees when the
            // component is not dragged.
            child: GestureDetector(
              onTap: () {
                Get.to(PageChitiet1(manga: manga));
              },
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsetsGeometry.fromLTRB(5, 10, 2, 5),
                      height: 160,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            mangaResources.imageBaseUrl + manga.thumbUrl,
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: controller_manga.fetchMangaDetail(manga.slug),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print("Lỗi rầu: ${snapshot.error.toString()}");
                          return Center(
                            child: Text(
                              "Lỗi rầu: ${snapshot.error.toString()}",
                            ),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        MangaDetail data = snapshot.data!;
                        DateTime time = DateTime.parse(
                          data.updatedAt,
                        ).toLocal();
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  manga.title,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                if (data.chapters.length != 0)
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(bottom: 5),
                                    child: Text(
                                      "Latest chapter ${data.chapters.length}",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),

                                Text(
                                  data.content
                                      .replaceAll("<p>", "")
                                      .replaceAll("</p>", ""),
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  data.author.join(", "),
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "${time.day}/${time.month}/${time.year}",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: controller_bookmark.mangas.length,
      ),
    );
  });
}
