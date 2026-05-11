class MangaModel {
  String title;
  String thumbUrl;
  String slug;

  MangaModel({required this.title, required this.thumbUrl, required this.slug});

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      title: json['name'] as String,
      thumbUrl: json['thumb_url'] as String,
      slug: json['slug'] as String,
    );
  }

  factory MangaModel.fromMap(Map<String, dynamic> map) {
    return MangaModel(
      title: map['title'] as String,
      thumbUrl: map['thumbUrl'] as String,
      slug: map['slug'] as String,
    );
  }
}
