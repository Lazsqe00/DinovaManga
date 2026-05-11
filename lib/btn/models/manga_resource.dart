class MangaResource {
  String name;
  String baseUrl;
  String imageBaseUrl;
  Map<String, String> endpoints;

  MangaResource({
    required this.name,
    required this.baseUrl,
    required this.imageBaseUrl,
    required this.endpoints,
  });
}

MangaResource mangaResources = MangaResource(
  name: "otruyen",
  // baseUrl + endpoints[key]!
  // baseUrl là gốc + đường dẫn endpoints đường dẫn đằng sau
  baseUrl: "https://otruyenapi.com/v1/api",
  // đường dẫn ảnh kết hợp với base
  imageBaseUrl: "https://img.otruyenapi.com/uploads/comics/",
  endpoints: {
    "home": "/home",
    "truyen_dang_phat_hanh": "/danh-sach/dang-phat-hanh",
    "truyen_moi": "/danh-sach/truyen-moi",
    "truyen_hoan_thanh": "/danh-sach/hoan-thanh",
    "truyen_coming_soon": "/danh-sach/sap-ra-mat",
    "the_loai": "/the-loai",
    "thong_tin_truyen": "/truyen-tranh",
    "tim_kiem": "/tim-kiem",
  },
);
