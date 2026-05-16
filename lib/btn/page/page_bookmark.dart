import 'package:dieu65130478_flutter_app/btn/widget/buildChapterList.dart';
import 'package:dieu65130478_flutter_app/btn/widget/buildMangaList.dart';
import 'package:flutter/material.dart';

class PageBookmark extends StatelessWidget {
  const PageBookmark({super.key});

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


}
