import 'package:dieu65130478_flutter_app/btn/controller/bookmark_controller.dart';
import 'package:dieu65130478_flutter_app/btn/controller/manga_controller.dart';
import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
import 'package:dieu65130478_flutter_app/btn/models/manga_model.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_danh_sach_chuong.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../models/manga_resource.dart';

class PageChitiet1 extends StatelessWidget {
  PageChitiet1({super.key, required this.manga});

  MangaModel manga;
  final controller = Get.find<MangaController>();
  final controllerBookmark = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đọc truyện'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Obx(
            () =>  IconButton(
                onPressed: () {
                  controllerBookmark.mangaBookmark(context, manga);
                },
                icon: controllerBookmark.isBookmarkManga(manga.slug)?Icon(Icons.bookmark_add):Icon(Icons.bookmark_add_outlined)
            ),
          )
        ],
      ),

      body: FutureBuilder<MangaDetail>(
        future: controller.fetchMangaDetail(manga.slug),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            print("Lỗi rầu: ${asyncSnapshot.error.toString()}");
            return Center(
              child: Text("Lỗi rầu: ${asyncSnapshot.error.toString()}"),
            );
          }
          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var detail = asyncSnapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  //chứa ảnh và thông tin truyện
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: .start,
                      children: [
                        Container(
                          margin: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 15),
                          height: 190,
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
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            mainAxisAlignment: .spaceBetween, //
                            children: [
                              Text(
                                manga.title,
                                style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontSize: 15,
                                  fontWeight: .bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text('Trạng thái: '),
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:  BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      '${detail.status}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text('Tác giả: ${detail.author}'),
                              Text('Thể loại: Đang cập nhật'),

                              SizedBox(
                                width: double.infinity,
                                //chiếm hết chiều ngang
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(PageDanhSachChuong(detail: detail,));
                                  },
                                  child: Text(
                                    'Đọc ngay',
                                    style: TextStyle(fontWeight: .bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purpleAccent.withValues(alpha: 0.5),
                                    foregroundColor: Colors.white
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  //Mô tả truyện
                  Text('Giới thiệu truyện:'),
                  SizedBox(height: 6),
                  ReadMoreText(
                    detail.content.replaceAll('<p>', '').replaceAll('</p>', ''),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    trimCollapsedText: 'Xem thêm',
                    trimExpandedText: 'Thu gọn',
                    moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    lessStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text('Danh sách chương: ${detail.chapters.length} chapter'),
                  SizedBox(height: 10),

                  Text('Gợi ý truyện:'),
                  Container(
                    height: 250,
                    margin: EdgeInsetsGeometry.all(2),
                    child: FutureBuilder<List<MangaModel>>(
                      future: controller.fetchManga("truyen_coming_soon"),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print("Lỗi rầu: ${snapshot.error.toString()}");
                          return Center(
                            child: Text("Lỗi rầu: ${snapshot.error.toString()}"),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<MangaModel> data = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return recentMangaCard(
                              manga: data[index],
                              context: context,
                            );
                          },
                          itemCount: data.length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget recentMangaCard({
  required MangaModel manga,
  required BuildContext context,
}) {
  // final controller = Get.find<MangaController>();
  return GestureDetector(
    onTap: () {
      Get.to(PageChitiet1(manga: manga,), preventDuplicates: false);//cho phép mở lại chính trang này
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
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
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
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
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
