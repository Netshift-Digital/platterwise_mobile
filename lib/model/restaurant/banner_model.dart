// To parse this JSON data, do
//
//     final banner = bannerFromJson(jsonString);

class BannerDetail {
  BannerDetail(
      {required this.banner,
      required this.name,
      this.descriptions,
      this.externalLink});

  String banner;
  String name;
  String? descriptions, externalLink;

  factory BannerDetail.fromJson(Map<String, dynamic> json) => BannerDetail(
      banner: json["banner"] ?? "",
      name: json["name"] ?? "",
      descriptions: json['descriptions'] ?? "",
      externalLink: json['external_link'] ?? "");

  Map<String, dynamic> toJson() => {
        "banner": banner,
        "name": name,
        "external_link": externalLink,
        "descriptions": descriptions,
      };
}

// To parse this JSON data, do
//
//     final banner = bannerFromJson(jsonString);

class PromotionalAdDetail {
  PromotionalAdDetail({
    required this.id,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.views,
  });
  int id;
  String title;
  String message;
  String imageUrl;
  int views;

  factory PromotionalAdDetail.fromJson(Map<String, dynamic> json) =>
      PromotionalAdDetail(
          id: json["id"] ?? 0,
          title: json["title"] ?? "",
          message: json['message'] ?? "",
          imageUrl: json['img_url'] ?? "",
          views: json['total_views'] ?? 0);
}
