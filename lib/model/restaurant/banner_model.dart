// To parse this JSON data, do
//
//     final banner = bannerFromJson(jsonString);

import 'dart:convert';

Banner bannerFromJson(String str) => Banner.fromJson(json.decode(str));

String bannerToJson(Banner data) => json.encode(data.toJson());

class Banner {
  Banner({
    required this.status,
    required this.allBannersList,
  });

  String status;
  List<AllBannersList> allBannersList;

  factory Banner.fromJson(Map<dynamic, dynamic> json) => Banner(
        status: json["status"],
        allBannersList: List<AllBannersList>.from(
            json["all_banners_list"].map((x) => AllBannersList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "all_banners_list":
            List<dynamic>.from(allBannersList.map((x) => x.toJson())),
      };
}

class AllBannersList {
  AllBannersList(
      {required this.banner,
      required this.name,
      this.descriptions,
      this.externalLink});

  String banner;
  String name;
  String? descriptions, externalLink;

  factory AllBannersList.fromJson(Map<String, dynamic> json) => AllBannersList(
      banner: json["banner"],
      name: json["name"],
      descriptions: json['descriptions'],
      externalLink: json['external_link']);

  Map<String, dynamic> toJson() => {
        "banner": banner,
        "name": name,
        "external_link": externalLink,
        "descriptions": descriptions,
      };
}
