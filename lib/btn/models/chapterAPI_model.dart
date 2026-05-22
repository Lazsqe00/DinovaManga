class ChapterDataAPI {
  String domainCdn;
  String chapterPath;
  List<String> images;

  ChapterDataAPI({
    required this.domainCdn,
    required this.chapterPath,
    required this.images,
  });

  factory ChapterDataAPI.fromJson(Map<String, dynamic> json) {
    var item = json['item'];
    List<String> ls = [
      for (var img in item['chapter_image']) img['image_file'].toString(),
    ];
    return ChapterDataAPI(
      domainCdn: json['domain_cdn'] as String,
      chapterPath: item['chapter_path'] as String,
      images: ls,
    );
  }
}
