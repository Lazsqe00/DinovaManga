import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/chapterAPI_model.dart';
import '../models/managa_detail.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';

// String mangaUrl = "https://otruyenapi.com/v1/api/danh-sach/truyen-moi";

class MangaController extends GetxController {
  var lsManga = <MangaModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<dynamic>> _fetchMangaData(String mangaUrl) async {
    final response = await http.get(Uri.parse(mangaUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData['data']['items'];
    } else {
      print("Không có dữ liệu trả về");
      return Future.error("Không có dữ liệu trả về");
    }
  }

  Future<List<MangaModel>> fetchManga(String key) async {
    final mangaUrl = mangaResources.baseUrl + mangaResources.endpoints[key]!;
    List<dynamic> items = await _fetchMangaData(mangaUrl);
    return items.map((e) => MangaModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> _fetchMangaDetail(String slug) async {
    final res = await http.get(
      Uri.parse(
        "${mangaResources.baseUrl}${mangaResources.endpoints["thong_tin_truyen"]}/$slug",
      ),
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return json['data']['item'];
    } else {
      print("Không có dữ liệu trả về");
      return Future.error("Không có dữ liệu trả về");
    }
  }

  Future<MangaDetail> fetchMangaDetail(String slug) async {
    final items = await _fetchMangaDetail(slug);
    return MangaDetail.fromJson(items);
  }

  Future<Map<String, dynamic>> _fetchChapterModel(String chapterApiUrl) async {
    final response = await http.get(Uri.parse(chapterApiUrl));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json["data"];
    } else {
      print("Không có dữ liệu trả về");
      return Future.error("Không thể tải nội dung truyện");
    }
  }

  Future<ChapterDataAPI> fetchChapterModel(String chapterApiUrl) async {
    final items = await _fetchChapterModel(chapterApiUrl);
    return ChapterDataAPI.fromJson(items);
  }
}
