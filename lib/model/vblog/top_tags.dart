// To parse this JSON data, do
//
//     final topTag = topTagFromJson(jsonString);

import 'dart:convert';

TopTag topTagFromJson(String str) => TopTag.fromJson(json.decode(str));

String topTagToJson(TopTag data) => json.encode(data.toJson());

class TopTag {
  TopTag({
    required this.status,
    required this.allTagRank,
  });

  String status;
  List<AllTagRank> allTagRank;

  TopTag copyWith({
    String? status,
    List<AllTagRank>? allTagRank,
  }) =>
      TopTag(
        status: status ?? this.status,
        allTagRank: allTagRank ?? this.allTagRank,
      );

  factory TopTag.fromJson(Map<dynamic, dynamic> json) => TopTag(
    status: json["status"],
    allTagRank: List<AllTagRank>.from(json["all_tag_rank"].map((x) => AllTagRank.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "all_tag_rank": List<dynamic>.from(allTagRank.map((x) => x.toJson())),
  };
}

class AllTagRank {
  AllTagRank({
   required this.tagRank,
  });

  String tagRank;

  AllTagRank copyWith({
    String? tagRank,
  }) =>
      AllTagRank(
        tagRank: tagRank ?? this.tagRank,
      );

  factory AllTagRank.fromJson(Map<dynamic, dynamic> json) => AllTagRank(
    tagRank: json["tag_rank"],
  );

  Map<String, dynamic> toJson() => {
    "tag_rank": tagRank,
  };
}
