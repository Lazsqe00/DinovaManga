import 'package:dieu65130478_flutter_app/btn/models/category_model.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_bookmark.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_category.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_network_error.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_search.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/history_controller.dart';
import '../controller/manga_controller.dart';
import '../controller/search_controller.dart';
import '../models/manga_model.dart';
import '../widget/new_releases_card.dart';
import '../widget/recent_manga_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDark') ?? false;

  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
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
  final searchController = Get.put(SearchMangaController());
  final historyController = Get.put(HistoryController());

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
            onPressed: () {
              showSearch(context: context, delegate: MangaSearchDelegate());
            },
            iconSize: 29.0,
          ),
          IconButton(
            icon: Icon(Icons.bookmark_border_outlined),
            onPressed: () {
              Get.to(Favorites());
            },
            iconSize: 29.0,
          ),
        ],
      ),

      body: GetBuilder<MangaController>(
        builder: (controller) {
          if (controller.isNetworkError) {
            return PageNetworkError(onRefresh: () => controller.refeshAll());
          }
          return RefreshIndicator(
            onRefresh: () async {
              return controller.refeshAll();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    margin: EdgeInsetsGeometry.fromLTRB(5, 10, 2, 5),
                    child: Text(
                      "Recent Manga",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
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
                            child: Text(
                              "Lỗi rầu: ${snapshot.error.toString()}",
                            ),
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

                  // Category
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Category",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 45,
                    margin: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 5),

                    child: FutureBuilder<List<CategoryModel>>(
                      future: controller.fetchCategories(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        List<CategoryModel> categories = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            return GestureDetector(
                              onTap: () =>
                                  Get.to(() => PageCategory(category: cat)),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  cat.name,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsGeometry.fromLTRB(5, 10, 0, 5),
                    child: Text(
                      "New Releases",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
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
                        itemBuilder: (context, index) => newReleasesCard(
                          manga: data[index],
                          context: context,
                        ),
                      );
                    },
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
