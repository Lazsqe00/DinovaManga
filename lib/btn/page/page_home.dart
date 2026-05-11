import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_bookmark.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_chitiet_testmau.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/manga_controller.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final controller = Get.put(MangaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manga Book'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
          iconSize: 29.0,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            iconSize: 29.0,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined),
            onPressed: () {
              Get.to(Favorites());
            },
            iconSize: 29.0,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
              margin: EdgeInsetsGeometry.fromLTRB(5, 10, 2, 5),
              child: Text(
                "Recent Manga",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              height: 250,
              margin: EdgeInsetsGeometry.all(2),
              child: FutureBuilder<List<MangaModel>>(
                future: controller.fetchManga("truyen_hoan_thanh"),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Lỗi rầu: ${snapshot.error.toString()}");
                    return Center(
                      child: Text("Lỗi rầu: ${snapshot.error.toString()}"),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
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
            Container(
              margin: EdgeInsetsGeometry.fromLTRB(5, 10, 0, 5),
              child: Text(
                "New Releases",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            FutureBuilder(
              future: controller.fetchManga("truyen_dang_phat_hanh"),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print("Lỗi rầu: ${snapshot.error.toString()}");
                  return Center(
                    child: Text("Lỗi rầu: ${snapshot.error.toString()}"),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<MangaModel> data = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) =>
                      newReleasesCard(manga: data[index], context: context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget recentMangaCard({
  required MangaModel manga,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      Get.to(PageChitiet1(manga: manga));
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
                  colors: [Colors.transparent, Colors.black87],
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
                    style: TextStyle(color: Colors.white60, fontSize: 13),
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

Widget newReleasesCard({
  required MangaModel manga,
  required BuildContext context,
}) {
  final controller = Get.find<MangaController>();
  return GestureDetector(
    onTap: () {
      Get.to(PageChitiet1(manga: manga));
    },
    child: Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsetsGeometry.fromLTRB(5, 10, 2, 5),
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
          FutureBuilder(
            future: controller.fetchMangaDetail(manga.slug),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("Lỗi rầu: ${snapshot.error.toString()}");
                return Center(
                  child: Text("Lỗi rầu: ${snapshot.error.toString()}"),
                );
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              MangaDetail data = snapshot.data!;
              DateTime time = DateTime.parse(data.updatedAt).toLocal();
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
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
                      if (data.chapters.length != 0)
                        Padding(
                          padding: EdgeInsetsGeometry.only(bottom: 5),
                          child: Text(
                            "Latest chapter ${data.chapters.length}",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),

                      Text(
                        data.content
                            .replaceAll("<p>", "")
                            .replaceAll("</p>", ""),
                        maxLines: 3,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      Text(
                        data.author.join(", "),
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
