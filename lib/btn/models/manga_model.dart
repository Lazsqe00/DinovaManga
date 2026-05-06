class MangaModel {
  String title;
  String thumbUrl;
  String slug;

  MangaModel({required this.title, required this.thumbUrl, required this.slug});

  Map<String, dynamic> toMap() {
    return {'title': this.title, 'thumbUrl': this.thumbUrl, 'slug': this.slug};
  }

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      title: json['name'] as String,
      thumbUrl: json['thumb_url'] as String,
      slug: json['slug'] as String,
    );
  }
}
