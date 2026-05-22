import 'package:dieu65130478_flutter_app/btn/widget/buildChapterList.dart';
import 'package:dieu65130478_flutter_app/btn/widget/buildMangaList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widget/manga_bookmark.dart';
import '../controller/bookmark_controller.dart';
import '../widget/chapter_bookmark.dart';


class Favorites extends StatelessWidget {
  final BookmarkController controller = Get.put(BookmarkController());


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bookmark', style: Theme.of(context).textTheme.headlineMedium,),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Text('Manga',),
                Text('Chapter'),
              ]
          ),
        ),
        body: TabBarView(
            children: [
              buildMangaList(context),
              buildChapterList(context)
            ]
        ),

      ),
    );
  }

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
          children: [buildMangaList(context), buildChapterList(context)],
        ),
      ),
    );
  }
}
