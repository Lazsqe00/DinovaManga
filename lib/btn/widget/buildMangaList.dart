import 'package:dieu65130478_flutter_app/btn/controller/bookmark_controller.dart';
import 'package:dieu65130478_flutter_app/btn/controller/manga_controller.dart';
import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
import 'package:dieu65130478_flutter_app/btn/models/manga_model.dart';
import 'package:dieu65130478_flutter_app/btn/models/manga_resource.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_chi_tiet.dart';
import 'package:dieu65130478_flutter_app/helper/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

Widget buildMangaList(BuildContext context) {
  final controller_manga = Get.find<MangaController>();
  // final controller_boomark = Get.find<BookmarkController>();
  final controller_boomark = Get.put(BookmarkController());
  return Obx(
    () {
      if(controller_boomark.mangas.isEmpty){
        return Center(
          child: Text("Chưa có truyện nào được lưu"),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller_boomark.mangas.length,
                  itemBuilder: (context, index) {
                    var manga = controller_boomark.mangas[index];
                    return Slidable(
                      endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                                onPressed: (context) {
                                  _xoa(context,manga);
                                },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Xóa',
                            ),
                          ]
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(PageChitiet1(manga: manga));
                        },
                        child: Card(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsetsGeometry.fromLTRB(5, 10, 2, 5),
                                width: 120,
                                height: 160,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: .cover,
                                      image: NetworkImage(
                                        mangaResources.imageBaseUrl + manga.thumbUrl
                                      )
                                  )
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: .start,
                                          children: [
                                            Text(
                                              manga.title,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                              "Latest chapter: ${data.chapters.length}",
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                                data.content.replaceAll("<p>", "").replaceAll("</p>", ""),
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
                              )
                            ],
                          ),
                        ),
                      ),
                    );

                  },
              ),
            )
          ],
        ),
      );
    },
  );
}

Future<void> _xoa(BuildContext context, MangaModel manga) async{
  final controllerBookmark = Get.find<BookmarkController>();
  String? confirm = await showConfirmDialog(
      context,
      "Bạn có muốn xóa ${manga.title}",
  );
  controllerBookmark.mangaBookmark(context, manga);
}
