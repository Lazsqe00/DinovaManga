import 'dart:convert';
import 'dart:ui';

import 'package:dieu65130478_flutter_app/btn/models/chapter_API_model.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_doc_truyen.dart';
import 'package:dieu65130478_flutter_app/helper/network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/managa_detail.dart';
import '../models/manga_model.dart';
import '../models/manga_resource.dart';

// String mangaUrl = "https://otruyenapi.com/v1/api/danh-sach/truyen-moi";

class MangaController extends GetxController {
  var lsManga = <MangaModel>[].obs;
  var isLoading = true.obs;

  var showChapters = true.obs; // ẩn/hiện điều hướng trang đọc truyện
  bool isNetworkError = false;

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
      final json = jsonDecode(
        response.body,
      ); //chuyển đổi về kdl mà Dart có thể hiểu được
      return json["data"];
    } else {
      return Future.error("Không thể tải nội dung truyện");
    }
  }

  Future<ChapterApiModel> fetchChapterModel(String chapterApiUrl) async{
    final item = await _fetchChapterModel(chapterApiUrl);
    return ChapterApiModel.fromMap(item);
  }

  List<String> getImagesURL(ChapterApiModel model){
    return model.chapterImage.map((value) => "${model.domainCdn}/${model.chapterPath}/$value",).toList();
  }

  void toggle() {
    showChapters.value = !showChapters.value;
  }

  void nextChapter(MangaDetail detail, int currentIndex, int offset) {
    var newIndex = currentIndex + offset;
    if (newIndex >= 0 && newIndex < detail.chapters.length) {
      var nextChapter = detail.chapters[newIndex];
      print("Đang chuyển tới: ${nextChapter.chapterName}");
      Get.off(
        () => PageDocTruyen(
          chuong: nextChapter.chapterName,
          chapter: nextChapter,
          detail: detail,
          currentIndex: newIndex,
        ),
        preventDuplicates: false,
      );
    }
    else {
      Get.rawSnackbar(
        message: "Không còn chương nào nữa!",
        maxWidth: 250,
        borderRadius: 30,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black38,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(bottom: 50),
      );
    }
  }

  Future<List<MangaModel>> fetchMangaWithNetworkCheck(String category) async{
    var isConnect = await checkConnectNetwork();
    if(isConnect==false){
      isNetworkError = true;
      throw Exception("Không có kêt nối Internet");
    }
    else{
      isNetworkError = false;
      return fetchManga(category);
    }
  }

  Future<void> refeshAll() async{
    bool isConnect = await checkConnectNetwork();
    if(isConnect==false){
      isNetworkError=true;
    }
    else{
      isNetworkError=false;
    }
    update();
    await Future.delayed(const Duration(milliseconds: 2000));
  }

}
