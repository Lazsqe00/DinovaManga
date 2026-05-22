class ChapterApiModel {
  String domainCdn;
  String chapterPath;
  List<String> chapterImage;

  ChapterApiModel({
    required this.domainCdn,
    required this.chapterPath,
    required this.chapterImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'domain_cdn': this.domainCdn,
      'chapter_path': this.chapterPath,
      'chapter_image': this.chapterImage,
    };
  }

  factory ChapterApiModel.fromMap(Map<String, dynamic> map) {
    var item = map["item"];
    List<String> listImage = [
      for(var img in item["chapter_image"])
        img["image_file"].toString()
    ];
    return ChapterApiModel(
      domainCdn: map['domain_cdn'] as String,
      chapterPath: item['chapter_path'] as String,
      chapterImage: listImage,
    );
  }
}