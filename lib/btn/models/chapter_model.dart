class ChapterModel {
  String filename;
  String chapterName;
  String chapterTitle;
  String chapterApiData;
  String slug;

  ChapterModel({
    required this.filename,
    required this.chapterName,
    required this.chapterTitle,
    required this.chapterApiData,
    required this.slug,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json, String mangaSlug) {
    return ChapterModel(
      filename: json['filename'] ?? '',
      chapterName: json['chapter_name'] ?? '',
      chapterTitle: json['chapter_title'] ?? '',
      chapterApiData: json['chapter_api_data'] ?? '',
      slug: mangaSlug,
    );
  }

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      filename: map['filename'] as String,
      chapterName: map['chapterName'] as String,
      chapterTitle: map['chapterTitle'] as String,
      chapterApiData: map['chapterApiData'] as String,
      slug: map['slug'] as String,
    );
  }
}
