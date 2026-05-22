// import 'package:dieu65130478_flutter_app/btn/controller/bookmark_controller.dart';
// import 'package:dieu65130478_flutter_app/btn/controller/manga_controller.dart';
// import 'package:dieu65130478_flutter_app/btn/models/chapter_model.dart';
// import 'package:dieu65130478_flutter_app/btn/page/page_doc_truyen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:get/get.dart';
//
// import '../helper/dialog.dart';
// import '../models/chapterAPI_model.dart';
// import '../models/managa_detail.dart';
//
// Widget buildChapterList(BuildContext context) {
//   final controllerManga = Get.find<MangaController>();
//   final controllerBookMark = Get.find<BookmarkController>();
//
//   return Obx(() {
//     if (controllerBookMark.chapters.isEmpty) {
//       return Center(child: Text("Chưa có chương nào được lưu"));
//     }
//     return ListView.separated(
//       itemBuilder: (context, index) {
//         var data = controllerBookMark.chapters[index];
//         ChapterModel chapter = data["chapter"];
//         MangaDetail detail = data["detail"];
//
//         return FutureBuilder(
//           future: controllerManga.fetchChapterModel(chapter.chapterApiData),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               print("Lỗi rầu: ${snapshot.error.toString()}");
//               return Center(
//                 child: Text("Lỗi rầu: ${snapshot.error.toString()}"),
//               );
//             }
//             if (!snapshot.hasData) {
//               return Center(child: CircularProgressIndicator());
//             }
//             ChapterDataAPI chapterAPI = snapshot.data!;
//             return Slidable(
//               endActionPane: ActionPane(
//                 motion: ScrollMotion(),
//                 children: [
//                   SlidableAction(
//                     onPressed: (context) {
//                       _xoa(context, chapter, detail);
//                     },
//                     backgroundColor: Colors.red,
//                     foregroundColor: Colors.white,
//                     icon: Icons.delete,
//                     label: 'Xóa',
//                   ),
//                 ],
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   int currentIndex = detail.chapters.indexWhere(
//                     (element) =>
//                         element.chapterApiData == chapter.chapterApiData,
//                   );
//                   Get.to(
//                     PageDocTruyen(
//                       chuong: chapter.chapterName,
//                       chapter: chapter,
//                       detail: detail,
//                       currentIndex: currentIndex,
//                     ),
//                   ); //nhấn 2 lần mới chuyển trang nên cập nhâật lại vị trí chương truyện
//                 },
//                 child: Card(
//                   child: Row(
//                     children: [
//                       Container(
//                         margin: EdgeInsetsGeometry.fromLTRB(5, 10, 2, 5),
//                         width: 120,
//                         height: 140,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             fit: .cover,
//                             image: NetworkImage(
//                               "${chapterAPI.domainCdn}/${chapterAPI.chapterPath}/${chapterAPI.images[2]}",
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: .start,
//                           children: [
//                             Text(
//                               "Chapter ${chapter.chapterName}",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                               maxLines: 1,
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               chapter.filename,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.black87,
//                               ),
//                               maxLines: 2,
//                             ),
//                             SizedBox(height: 12),
//                             Container(
//                               padding: EdgeInsetsGeometry.fromLTRB(
//                                 10,
//                                 5,
//                                 10,
//                                 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[200],
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Text(
//                                 "Đã lưu",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//       separatorBuilder: (context, index) => Divider(),
//       itemCount: controllerBookMark.chapters.length,
//     );
//   });
// }
//
// void _xoa(
//   BuildContext context,
//   ChapterModel chapter,
//   MangaDetail detail,
// ) async {
//   final controllerBookmart = Get.find<BookmarkController>();
//   String? confirm = await showConfirmDialog(
//     context,
//     "Bạn có muốn xóa Chapter ${chapter.chapterName}",
//   );
//   if (confirm == "ok") {
//     controllerBookmart.chapterBookmark(context, chapter);
//   }
// }
