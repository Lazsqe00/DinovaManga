import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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


  // hàm lấy dữ liệu từ API, mới truy xuất dữ liệu trong item nhưng chưa xử lí

  Future<List<dynamic>> _fetchMangaData(String mangaUrl) async {
    final response = await http.get(Uri.parse(mangaUrl));
    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về
      // Ví dụ: chuyển đổi JSON thành danh sách đối tượng
      // dấu ngoặc nhọn là 1 cái map
      // trước tiên là dữ liệu thô, sau đó cần decode để chuyển thành Map<String, dynamic>
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      // vô data trước xong vô items
      // trả về trong items có những cái item có [], trong [] kiểu vể về truy xuất dữ liệu trong map, 1 cái list dynamic
      return jsonData['data']['items'];
    } else {
      print("Không có dữ liệu trả về");
      return Future.error("Không có dữ liệu trả về");
    }
  }
  // mỗi cái item là 1 cái map
  // mục tiêu là chuyển map thành model (object)

  // <String, dynamic>


  // tác dụng chính là chuyển List<dynamic> thành 1 cái List<Model>
  Future<List<MangaModel>> fetchManga(String key) async {
    // baseUrl là gốc + đường dẫn endpoints đường dẫn đằng sau
    final mangaUrl = mangaResources.baseUrl + mangaResources.endpoints[key]!;
    // gọi hàm _fetchMangaData để lấy dữ liệu từ API, mới truy xuất dữ liệu trong item nhưng chưa xử lí
    // trả về là List<dynamic> từ hàm _fetchMangaData, sử dụng hàm bất đồng bộ để lấy dữ liệu trả về, đợi hàm xử lí xong sẽ lưu vào cái List<dynamic>
    List<dynamic> items = await _fetchMangaData(mangaUrl);
    // chuyển đổi dữ liệu từ JSON thành đối tượng MangaModel
    // chuyển từng đối tượng từ map thành đối tượng MangaModel
    // dùng fromJson(e) từ bên MangaModel để chuyển đổi dữ liệu từ JSON thành đối tượng MangaModel
    // e là List<Map<String, dynamic>>
    return items.map((e) => MangaModel.fromJson(e)).toList();
  }

  // lấy dữ liệu chi tiết truyện
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
}
