import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../controller/history_controller.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';
import 'page_chi_tiet.dart';

class PageHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HistoryController historyController = Get.find<HistoryController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử xem'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (historyController.historyList.isEmpty) {
          return Center(child: Text('Chưa có lịch sử xem'));
        }
        return ListView.separated(
          padding: EdgeInsets.all(8),
          itemCount: historyController.historyList.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            MangaModel manga = historyController.historyList[index];
            return Slidable(
              key: ValueKey(manga.slug),
              // Luật sang trái để hiện nút xóa
              endActionPane: ActionPane(
                motion: DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (_) async {
                      // Hỏi xác nhận trước khi xóa
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Xóa lịch sử'),
                          content: Text(
                            'Bạn có chắc muốn xóa "${manga.title}" khỏi lịch sử?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(
                                'Xóa',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        historyController.removeFromHistory(manga.slug);
                      }
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Xóa',
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(8),
                leading: Card(
                  margin: EdgeInsets.zero,
                  child: Image.network(
                    mangaResources.imageBaseUrl + manga.thumbUrl,
                    width: 60,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  manga.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  historyController.addToHistory(manga);
                  Get.to(() => PageChitiet1(manga: manga));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
