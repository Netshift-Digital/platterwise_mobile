// To parse this JSON data, do
//
//     final resuarantReview = resuarantReviewFromJson(jsonString);

import 'dart:convert';

RestaurantReview restaurantReviewFromJson(String str) => RestaurantReview.fromJson(json.decode(str));

String restaurantReviewToJson(RestaurantReview data) => json.encode(data.toJson());

class RestaurantReview {
  RestaurantReview({
    required this.status,
    required this.allRestReview,
  });

  String status;
  List<AllRestReview> allRestReview;

  factory RestaurantReview.fromJson(Map<String, dynamic> json) => RestaurantReview(
    status: json["status"],
    allRestReview: List<AllRestReview>.from(json["all_rest_review"].map((x) => AllRestReview.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "all_rest_review": List<dynamic>.from(allRestReview.map((x) => x.toJson())),
  };
}

class AllRestReview {
  AllRestReview({
    required this.firebaseAuthIDx,
    required this.rateId,
    required this.fullName,
    required this.profileUrl,
    required this.rating,
    required this.review,
    required this.timestamp,
  });

  String firebaseAuthIDx;
  String rateId;
  String fullName;
  String profileUrl;
  String rating;
  String review;
  String timestamp;

  factory AllRestReview.fromJson(Map<String, dynamic> json) => AllRestReview(
    firebaseAuthIDx: json["firebaseAuthIDx"],
    rateId: json["rate_id"],
    fullName: json["full_name"],
    profileUrl: json["profileUrl"],
    rating: json["rating"],
    review: json["review"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "firebaseAuthIDx": firebaseAuthIDx,
    "rate_id": rateId,
    "full_name": fullName,
    "profileUrl": profileUrl,
    "rating": rating,
    "review": review,
    "timestamp": timestamp,
  };
}
