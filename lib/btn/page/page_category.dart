import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/manga_controller.dart';
import '../models/category_model.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';
import 'page_chi_tiet.dart';
import '../controller/history_controller.dart';

class PageCategory extends StatelessWidget {
  final CategoryModel category;

  const PageCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MangaController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Thể Loại: ${category.name}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<MangaModel>>(
        future: controller.fetchMangaByCategory(category.slug),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<MangaModel> data = snapshot.data!;
          if (data.isEmpty) {
            return Center(child: Text("Không có truyện nào"));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _categoryMangaCard(data[index], context, controller);
            },
          );
        },
      ),
    );
  }
}

// Card hiển thị manga trong trang thể loại (giống New Releases)
Widget _categoryMangaCard(
  MangaModel manga,
  BuildContext context,
  MangaController controller,
) {
  return GestureDetector(
    onTap: () {
      Get.find<HistoryController>().addToHistory(manga);
      Get.to(() => PageChitiet1(manga: manga));
    },
    child: Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa
          Container(
            margin: EdgeInsets.fromLTRB(5, 10, 2, 5),
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
          // Thông tin chi tiết
          FutureBuilder<MangaDetail>(
            future: controller.fetchMangaDetail(manga.slug),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Không tải được"),
                );
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              MangaDetail detail = snapshot.data!;
              DateTime time = DateTime.parse(detail.updatedAt).toLocal();
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
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
                      if (detail.chapters.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            "Latest chapter ${detail.chapters.length}",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      Text(
                        detail.content
                            .replaceAll("<p>", "")
                            .replaceAll("</p>", ""),
                        maxLines: 3,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      Text(
                        detail.author.join(", "),
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
