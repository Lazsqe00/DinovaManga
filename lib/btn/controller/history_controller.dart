import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/manga_model.dart';

class HistoryController extends GetxController {

  var historyList = <MangaModel>[].obs;

  static const String _key = 'manga_history'; // Key lưu trong SharedPreferences
  static const int _maxHistory = 20; // số lượng tối đa lưu

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  // Đọc lịch sử đã lưu từ SharedPreferences
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList(_key) ?? [];
    historyList.value = savedList.map((item) {
      // phân tách chuỗi thành các phần tử
      final parts = item.split('|||');
      return MangaModel(slug: parts[0], title: parts[1], thumbUrl: parts[2]);
    }).toList();
  }

  // Thêm manga vào lịch sử
  Future<void> addToHistory(MangaModel manga) async {
    // Xóa nếu đã tồn tại
    historyList.removeWhere((m) => m.slug == manga.slug);

    // Thêm đầu
    historyList.insert(0, manga);

    // tối đa danh sách
    if (historyList.length > _maxHistory) {
      historyList.removeLast();
    }

    // Lưu vào SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      historyList.map((m) => '${m.slug}|||${m.title}|||${m.thumbUrl}').toList(),
    );
  }

  // Xóa toàn bộ lịch sử
  Future<void> clearHistory() async {
    historyList.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
