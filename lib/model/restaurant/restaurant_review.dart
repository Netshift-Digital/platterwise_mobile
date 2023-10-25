// To parse this JSON data, do
//
//     final resuarantReview = resuarantReviewFromJson(jsonString);

import 'dart:convert';

RestaurantReview restaurantReviewFromJson(String str) =>
    RestaurantReview.fromJson(json.decode(str));

class RestaurantReview {
  RestaurantReview({
    required this.status,
    required this.allRestReview,
  });

  String status;
  List<AllRestReview> allRestReview;

  factory RestaurantReview.fromJson(Map<String, dynamic> json) =>
      RestaurantReview(
        status: json["status"],
        allRestReview: List<AllRestReview>.from(
            json["all_rest_review"].map((x) => AllRestReview.fromJson(x))),
      );
}

class AllRestReview {
  AllRestReview({
    required this.restId,
    required this.reviewId,
    required this.fullName,
    required this.profileUrl,
    required this.rating,
    required this.review,
    required this.timestamp,
  });

  dynamic restId;
  dynamic reviewId;
  String fullName;
  String profileUrl;
  String rating;
  String review;
  String timestamp;

  factory AllRestReview.fromJson(Map<String, dynamic> json) => AllRestReview(
        restId: json["restaurant_id"] ?? 0,
        reviewId: json["id"] ?? 0,
        fullName: json["full_name"] ?? "",
        profileUrl: json["profileUrl"] ?? "",
        rating: json["star_rating"] ?? 0,
        review: json["comment"] ?? "",
        timestamp: json["created_at"] ?? "",
      );
}
