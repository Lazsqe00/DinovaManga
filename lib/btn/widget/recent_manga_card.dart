import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/history_controller.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';
import '../page/page_chi_tiet.dart';

Widget recentMangaCard({
  required MangaModel manga,
  required BuildContext context,
}) {

  return GestureDetector(
    onTap: () {
      Get.find<HistoryController>().addToHistory(manga);
      Get.to(
        PageChitiet1(manga: manga),
        preventDuplicates: false,
      );
    },
    child: Container(
      margin: EdgeInsetsGeometry.fromLTRB(5, 10, 2, 5),
      height: 200,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(mangaResources.imageBaseUrl + manga.thumbUrl),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    manga.title,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "Chương mới nhất",
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
