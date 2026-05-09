import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/manga_model.dart';
import '../models/manga_resource.dart';

class SearchMangaController extends GetxController {
  // Danh sách kết quả tìm kiếm
  var searchResults = <MangaModel>[].obs;

  // Trạng thái đang tải hay không
  var isLoading = false.obs;

  // Thông báo lỗi (rỗng nghĩa là không có lỗi)
  var errorMessage = ''.obs;

  // Hàm gọi API tìm kiếm truyện theo tên
  Future<void> searchManga(String keyword) async {
    // Nếu từ khóa rỗng thì xóa kết quả và dừng
    if (keyword.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Tạo URL tìm kiếm: /tim-kiem?keyword=...
      final url =
          '${mangaResources.baseUrl}${mangaResources.endpoints['tim_kiem']}?keyword=$keyword';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List items = json['data']['items'];

        // Chuyển từng item JSON thành MangaModel
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
