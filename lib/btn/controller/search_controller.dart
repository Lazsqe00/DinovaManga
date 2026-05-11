import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/manga_model.dart';
import '../models/manga_resource.dart';

class MangaSearchController extends GetxController {

  List<MangaModel> searchResults = [];
  bool isSearching = false;
  String currentQuery = '';

  int _currentPage = 1;
  int _totalPages = 1;

  // gọi API
  Future<List<MangaModel>> _fetchFromApi(String keyword, int page) async {
    final url = Uri.parse(
      '${mangaResources.baseUrl}${mangaResources.endpoints["tim_kiem"]}',
    ).replace(queryParameters: {
      'keyword': keyword.trim(),
      'page': page.toString(),
    });

    final res = await http.get(url);

    if (res.statusCode != 200) {
      print("Lỗi kết nối: ${res.statusCode}");
      return [];
    }

    final json = jsonDecode(res.body);

    // Lưu lại tổng số trang để biết khi nào dừng load more
    final pagination = json['data']['params']?['pagination'];
    if (pagination != null) {
      _totalPages = (pagination['totalPages'] ?? 1) as int;
    }

    final List items = json['data']['items'] ?? [];
    return items.map((e) => MangaModel.fromJson(e)).toList();
  }

  // tìm kiếm
  Future<void> search(String keyword, {int page = 1}) async {
    if (keyword.trim().isEmpty) return;

    isSearching = true;
    currentQuery = keyword;
    _currentPage = page;

    try {
      final items = await _fetchFromApi(keyword, page);
      if (page == 1) {
        searchResults = items; // thay thế danh sách
      } else {
        searchResults.addAll(items); // thêm vào danh sách
      }
    } finally {
      isSearching = false;
    }
  }

  // hiển thị thêm khi cuộn xuống cuối
  Future<void> loadMore() async {
    final bool canLoadMore = _currentPage < _totalPages && !isSearching;
    if (canLoadMore) {
      await search(currentQuery, page: _currentPage + 1);
    }
  }

  /// xóa ô tìm kiếm.
  void clearSearch() {
    searchResults = [];
    currentQuery = '';
    _currentPage = 1;
    _totalPages = 1;
  }
}
