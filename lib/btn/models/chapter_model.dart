class ChapterModel {
  String filename;
  String chapterName;
  String chapterTitle;
  String chapterApiData;

  ChapterModel({
    required this.filename,
    required this.chapterName,
    required this.chapterTitle,
    required this.chapterApiData,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      filename: json['filename'] ?? '',
      chapterName: json['chapter_name'] ?? '',
      chapterTitle: json['chapter_title'] ?? '',
      chapterApiData: json['chapter_api_data'] ?? '',
    );
  }
}
