import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/history_controller.dart';
import '../controller/manga_controller.dart';
import '../models/managa_detail.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';
import '../page/page_chi_tiet.dart';

Widget newReleasesCard({
  required MangaModel manga,
  required BuildContext context,
}) {
  final controller = Get.find<MangaController>();
  return GestureDetector(
    onTap: () {
      Get.find<HistoryController>().addToHistory(manga);
      Get.to(PageChitiet1(manga: manga));
    },
    child: Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsetsGeometry.fromLTRB(5, 10, 2, 5),
            height: 170,
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
            future: controller.fetchMangaDetail(manga.slug),
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
              MangaDetail data = snapshot.data!;
              DateTime time = DateTime.parse(data.updatedAt).toLocal();
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
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
  );
}
