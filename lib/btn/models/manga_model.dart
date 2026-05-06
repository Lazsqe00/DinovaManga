class MangaModel {
  String title; // tên truyện
  String thumbUrl; // đường dẫn URL hình ảnh truyện
  String slug; // slug là 1 cái đường dẫn để chuyển qua trang chi tiết

  MangaModel({
    required this.title,
    required this.thumbUrl,
    required this.slug,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'thumbUrl': this.thumbUrl,
      'slug': this.slug,
    };
  }

  // hàm để chuyển đổi dữ liệu từ JSON thành đối tượng MangaModel
  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      title: json['name'] as String,
      thumbUrl: json['thumb_url'] as String,
      slug: json['slug'] as String,
    );
  }
}
