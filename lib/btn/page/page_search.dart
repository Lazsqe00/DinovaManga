import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/search_controller.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';


class MangaSearchDelegate extends SearchDelegate {

  final SearchMangaController searchController =
      Get.find<SearchMangaController>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // Nút xóa
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
        close(context, null); // Đóng tìm kiếm
      },
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    // Gọi API tìm kiếm với từ khóa
    searchController.searchManga(query);
    return _buildResultList();
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    // gợi ý tìm kiếm
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

      // Không có kết quả
      if (searchController.searchResults.isEmpty) {
        return Center(child: Text('Không tìm thấy truyện nào'));
      }

      // Có kết quả
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
          // nếu ảnh lỗi
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

      // nhấn vào truyện, chuyển sang trang chi tiết
      onTap: () {
        close(context, manga.slug);
      },
    );
  }
}
