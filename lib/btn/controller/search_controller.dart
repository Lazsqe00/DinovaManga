import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/manga_model.dart';
import '../models/manga_resource.dart';

class SearchMangaController extends GetxController {

  var searchResults = <MangaModel>[].obs;

  var isLoading = false.obs;

  var errorMessage = ''.obs;

  Future<void> searchManga(String keyword) async {
    if (keyword.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final url =
          '${mangaResources.baseUrl}${mangaResources.endpoints['tim_kiem']}?keyword=$keyword';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List items = json['data']['items'];

        searchResults.value = items.map((e) => MangaModel.fromJson(e)).toList();
      } else {
        errorMessage.value = 'Không tìm thấy kết quả.';
        searchResults.clear();
      }
    } catch (e) {
      errorMessage.value = 'Lỗi kết nối: $e';
      searchResults.clear();
    }

    isLoading.value = false;
  }
}
