import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/history_controller.dart';
import '../controller/search_controller.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';
import 'page_chi_tiet.dart';


class MangaSearchDelegate extends SearchDelegate {

  final SearchMangaController searchController =
      Get.find<SearchMangaController>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    searchController.searchManga(query);
    return _buildResultList();
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    searchController.searchManga(query);
    return _buildResultList();
  }


  Widget _buildResultList() {
    return Obx(() {

      if (searchController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }


      if (searchController.errorMessage.value.isNotEmpty) {
        return Center(child: Text(searchController.errorMessage.value));
      }

      if (query.isEmpty) {
        return Center(child: Text('Nhập tên truyện để tìm kiếm'));
      }

      if (searchController.searchResults.isEmpty) {
        return Center(child: Text('Không tìm thấy truyện nào'));
      }


      List<MangaModel> results = searchController.searchResults;
      return ListView.separated(
          itemBuilder: (context, index) {
            return _mangaListItem(results[index], context);
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: results.length
      );
    });
  }


  Widget _mangaListItem(MangaModel manga, BuildContext context) {
    return ListTile(
      // Ảnh
      leading: Card(
        child: Image.network(
          mangaResources.imageBaseUrl + manga.thumbUrl,
          width: 50,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, size: 50);
          },
        ),
      ),

      // Tên
      title: Text(
        manga.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 20),
      ),

      onTap: () {
        close(context, null);
        Get.find<HistoryController>().addToHistory(manga);
        Get.to(() => PageChitiet1(manga: manga));
      },
    );
  }
}
