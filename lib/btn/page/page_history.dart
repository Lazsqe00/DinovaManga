import 'package:flutter/material.dart';
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
        actions: [
          // Nút xóa toàn bộ lịch sử
          IconButton(
            icon: Icon(Icons.delete_outline),
            tooltip: 'Xóa lịch sử',
            onPressed: () {
              historyController.clearHistory();
            },
          ),
        ],
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
            return ListTile(
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
                Get.to(
                  () => PageChitiet1(manga: manga),
                );
              },
            );
          },
        );
      }),
    );
  }
}
