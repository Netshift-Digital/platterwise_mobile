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
