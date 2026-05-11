import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widget/manga_bookmark.dart';
import '../controller/bookmark_controller.dart';

class Favorites extends StatelessWidget {
  final BookmarkController controller = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Bookmarks",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(text: "Manga"),
              Tab(text: "Chapters"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildMangaList(context),
            //buildChapter
          ],
        ),
      ),
    );
  }
}
