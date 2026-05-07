import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/manga_model.dart';
import '../models/manga_resource.dart';

class MangaSearchController extends GetxController {
  var searchResults = <MangaModel>[].obs;
  var isSearching = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var currentQuery = ''.obs;

  // lấy dữ liệu tìm kiếm từ API
  Future<List<dynamic>> _fetchSearchData(String keyword, int page) async {
    final uri = Uri.parse(
      '${mangaResources.baseUrl}${mangaResources.endpoints["tim_kiem"]}',
    ).replace(queryParameters: {
      'keyword': keyword.trim(),
      'page': page.toString(),
    });

    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final pagination = json['data']['params']?['pagination'];
      if (pagination != null) {
        totalPages.value = (pagination['totalPages'] ?? 1) as int;
      }
      return json['data']['items'] ?? [];
    } else {
      print("Không có dữ liệu trả về");
      return Future.error("Không có dữ liệu trả về");
    }
  }

  Future<void> search(String keyword, {int page = 1}) async {
    if (keyword.trim().isEmpty) return;

    isSearching.value = true;
    currentQuery.value = keyword;
    currentPage.value = page;

    try {
      final items = await _fetchSearchData(keyword, page);
      final results = items.map((e) => MangaModel.fromJson(e)).toList();

      if (page == 1) {
        searchResults.value = results;
      } else {
        searchResults.addAll(results);
      }
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadMore() async {
    if (currentPage.value < totalPages.value && !isSearching.value) {
      await search(currentQuery.value, page: currentPage.value + 1);
    }
  }

  void clearSearch() {
    searchResults.clear();
    currentQuery.value = '';
    currentPage.value = 1;
    totalPages.value = 1;
  }
}
