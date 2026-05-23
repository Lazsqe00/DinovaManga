import 'package:dieu65130478_flutter_app/btn/controller/manga_controller.dart';
import 'package:dieu65130478_flutter_app/btn/models/chapter_model.dart';
import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/bookmark_controller.dart';
import '../models/chapterAPI_model.dart';

class PageDocTruyen extends StatelessWidget {
  PageDocTruyen({
    super.key,
    required this.chuong,
    required this.chapter,
    required this.detail,
    required this.currentIndex,
  });

  String chuong;
  ChapterModel chapter;
  MangaDetail detail;
  int currentIndex;
  final controller = Get.find<MangaController>();
  final controllerBookmart = Get.find<BookmarkController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body tràn dưới AppBar
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        //định nghĩa size cho appBar
        child: Obx(
          () => controller.showChapters.value
              ? AppBar(
                  title: Text('Chương ${chuong}'),
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.black.withValues(alpha: 0.35),
                  elevation: 0,

                  actions: [
                    IconButton(
                      onPressed: () {
                        controllerBookmart.chapterBookmark(context, chapter);
                      },
                      icon:
                          controllerBookmart.isBookmarkedChapter(
                            chapter.chapterApiData,
                          )
                          ? Icon(Icons.star)
                          : Icon(Icons.star_border),
                    ),
                  ],
                )
              : SizedBox.shrink(), //trả về rồng nếu false
        ),
      ),
      //THANH ĐIỀU HƯỚNG DƯỚI
      bottomNavigationBar: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: controller.showChapters.value ? 70 : 0, // Ẩn hiện
          child: controller.showChapters.value
              ? BottomAppBar(
                  color: Colors.black.withValues(alpha: 0.35),
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                          controller.nextChapter(
                            context,
                            detail,
                            currentIndex,
                            -1,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.pop(context);
                          controller.nextChapter(
                            context,
                            detail,
                            currentIndex,
                            1,
                          );
                        },
                      ),
                    ],
                  ),
                )
              : null,
        ),
      ),
      //HIỂN THỊ ẢNH
      body: GestureDetector(
        onTap: () => controller.toggle(),
        child: FutureBuilder<ChapterDataAPI>(
          future: controller.fetchChapterModel(chapter.chapterApiData),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasError) {
              return Center(
                child: Text('Lỗi: ${asyncSnapshot.error.toString()}'),
              );
            }
            if (!asyncSnapshot.hasData) {
              return Center(child: CircularProgressIndicator()); //vòng quay
            }

            var data = asyncSnapshot.data!;
            // final String domain = data['domain_cdn'];
            // final item = data['item'];
            // final String path = item['chapter_path'];
            // final List images = item['chapter_image'];
            print(
              "Snapshot data: ${asyncSnapshot.data}",
            ); // Kiểm tra xem data có thực sự tồn tại không
            print("Đang chuẩn bị vào hàm getImagesURL...");
            var getImages = controller.getImagesURL(asyncSnapshot.data!);
            return ListView.builder(
              //lướt tới đâu render tới đó
              padding: EdgeInsets.zero,
              itemCount: getImages.length,
              itemBuilder: (context, index) {
                return Image.network(
                  getImages[index],
                  fit: BoxFit.fitWidth,
                  //tự co dãn để lắp đầy chiểu rộng khung chứa
                  loadingBuilder: (context, child, loadingProgress) {
                    //hiệu ứng chờ
                    if (loadingProgress == null) return child; //trả về ảnh
                    return Container(
                      height: 200,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ), //vòng quay
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 100,
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
