// To parse this JSON data, do
//
//     final searchRestaurantModel = searchRestaurantModelFromJson(jsonString);

import 'dart:convert';

import 'package:platterwave/model/restaurant/restaurant.dart';

SearchRestaurantModel searchRestaurantModelFromJson(String str) => SearchRestaurantModel.fromJson(json.decode(str));

String searchRestaurantModelToJson(SearchRestaurantModel data) => json.encode(data.toJson());

class SearchRestaurantModel {
  SearchRestaurantModel({
    required this.status,
    required this.searchResult,
  });

  String status;
  List<RestaurantData> searchResult;

  factory SearchRestaurantModel.fromJson(Map<String, dynamic> json) => SearchRestaurantModel(
    status: json["status"],
    searchResult: List<RestaurantData>.from(json["search_result"].map((x) => RestaurantData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "search_result": List<dynamic>.from(searchResult.map((x) => x.toJson())),
  };
}



