import 'package:dieu65130478_flutter_app/btn/controller/manga_controller.dart';
import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../models/manga_resource.dart';

class PageChitiet extends StatelessWidget {
  PageChitiet({super.key});

  final controller = Get.find<MangaController>();

  @override
  Widget build(BuildContext context) {
    // final manga = Get.arguments;//lấy dữ liệu từ trang page_home
    final manga = controller.currentManga.value;
    if (manga == null) {
      return Scaffold(
        body: Center(child: Text("Không tìm thấy dữ liệu truyện")),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Đọc truyện'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                              // SizedBox(height: 10),
                              Text('Tác giả: ${detail.author}'),
                              // SizedBox(height: 10),
                              Text('Thể loại: Đang cập nhật'),
                              // SizedBox(height: 10),
                              Row(
                                children: [
                                  Text('Đánh giá: '),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 20,
                                  ),
                                  Text('4.5'),
                                ],
                              ),
                              // SizedBox(height: 10),

                              SizedBox(
                                width: double.infinity,
                                //chiếm hết chiều ngang
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Đọc ngay',
                                    style: TextStyle(fontWeight: .bold),
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

                  // Row(
                  //   children: [
                  //     Text('Sắp xếp theo:'),
                  //
                  //   ],
                  // )
                  GestureDetector(
                    onTap: () => controller.toggleSort(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        // Tạo nền nhạt cho nút
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text('Sắp xếp:'),
                          Obx(
                            () => Icon(
                              controller.isAscending.value
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 16,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Container(
                    height: 300,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 3,
                      ), // Tạo viền cho khung

                    ),
                    child: Scrollbar(
                      child: Obx(() {
                        var xsChapter = controller.isAscending.value?detail.chapters:detail.chapters.reversed.toList();
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            final chapter = xsChapter[index];
                            return ListTile(
                              dense: true,
                              title: Text('Chương ${chapter.chapterName}'),
                              trailing: Icon(
                                Icons.keyboard_arrow_right,
                                size: 18,
                              ),
                              onTap: () {
                                //chuyển đến trang đọc truyện
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: detail.chapters.length,
                        );
                      },
                      ),
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
