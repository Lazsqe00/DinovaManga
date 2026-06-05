import 'category_model.dart';
import 'chapter_model.dart';

class MangaDetail {
  String title;
  String content;
  List<String> author;
  String status;
  String updatedAt;
  List<ChapterModel> chapters;
  List<CategoryModel> categories;

  MangaDetail({
    required this.title,
    required this.content,
    required this.author,
    required this.status,
    required this.chapters,
    required this.updatedAt,
    required this.categories
  });

  factory MangaDetail.fromJson(Map<String, dynamic> json) {
    final chapters = json['chapters'];
    String slug = json['slug'];
    List<ChapterModel> chapterList = [];
    if (chapters.isNotEmpty) {
      var chapterRaw = json['chapters'][0]['server_data'];

      chapterList = chapterRaw
          .map<ChapterModel>((c) => ChapterModel.fromJson(c, slug))
          .toList();
    }


    var listCategory = json['category'] as List? ??[];

    var categories = listCategory.map((e) => CategoryModel.fromJson(e),).toList();

    return MangaDetail(
      title: json['name'] ?? '',
      content: json['content'] ?? '',
      author: List<String>.from(json['author'] ?? []),
      status: json['status'] ?? '',
      updatedAt: json['updatedAt'],
      chapters: chapterList,
      categories: categories
    );
  }
}
