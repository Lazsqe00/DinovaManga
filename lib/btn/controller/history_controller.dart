import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/manga_model.dart';

class HistoryController extends GetxController {

  var historyList = <MangaModel>[].obs;

  static const String _key = 'manga_history';
  static const int _maxHistory = 20;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedList = prefs.getStringList(_key) ?? [];
    historyList.value = savedList.map((item) {
      final parts = item.split('|||');
      return MangaModel(slug: parts[0], title: parts[1], thumbUrl: parts[2]);
    }).toList();
  }

  // Thêm manga vào lịch sử
  Future<void> addToHistory(MangaModel manga) async {
    historyList.removeWhere((m) => m.slug == manga.slug);

    historyList.insert(0, manga);

    if (historyList.length > _maxHistory) {
      historyList.removeLast();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      historyList.map((m) => '${m.slug}|||${m.title}|||${m.thumbUrl}').toList(),
    );
  }

  Future<void> removeFromHistory(String slug) async {
    historyList.removeWhere((m) => m.slug == slug);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      historyList.map((m) => '${m.slug}|||${m.title}|||${m.thumbUrl}').toList(),
    );
  }


  Future<void> clearHistory() async {
    historyList.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
