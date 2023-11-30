import 'dart:convert';

import 'package:platterwave/model/restaurant/restaurant.dart';

SearchRestaurantModel searchRestaurantModelFromJson(String str) =>
    SearchRestaurantModel.fromJson(json.decode(str));

class SearchRestaurantModel {
  SearchRestaurantModel({
    required this.status,
    required this.searchResult,
  });

  String status;
  List<RestaurantData> searchResult;

  factory SearchRestaurantModel.fromJson(Map<String, dynamic> json) =>
      SearchRestaurantModel(
        status: "",
        searchResult: List<RestaurantData>.from(
            json["data"].map((x) => RestaurantData.fromJson(x))),
      );
}
