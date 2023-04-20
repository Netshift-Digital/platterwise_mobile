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

class SearchResult {
  SearchResult({
    required this.restId,
    required this.restuarantName,
    required this.restOwnerName,
    required this.restOwnerPic,
    required this.phone,
    required this.address,
    required this.state,
    required this.localGovt,
    required this.landmark,
    required this.coverPic,
    required this.banner,
    required this.descriptions,
    required this.openingHour,
    required this.days,
    required this.email,
    required this.website,
    required this.socialHandle,
    required this.rating,
    required this.menuPic,
  });

  String restId;
  String restuarantName;
  String restOwnerName;
  String restOwnerPic;
  String phone;
  String address;
  String state;
  String localGovt;
  String landmark;
  String coverPic;
  String banner;
  String descriptions;
  String openingHour;
  String days;
  String email;
  String website;
  String socialHandle;
  double rating;
  List<String> menuPic;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
    restId: json["rest_id"],
    restuarantName: json["restuarant_name"],
    restOwnerName: json["rest_owner_name"],
    restOwnerPic: json["rest_owner_pic"],
    phone: json["phone"],
    address: json["address"],
    state: json["state"],
    localGovt: json["local_govt"],
    landmark: json["landmark"],
    coverPic: json["cover_pic"],
    banner: json["banner"],
    descriptions: json["descriptions"],
    openingHour: json["opening_hour"],
    days: json["days"],
    email: json["email"],
    website: json["website"],
    socialHandle: json["social_handle"],
    rating: json["rating"]?.toDouble(),
    menuPic: List<String>.from(json["menu_pic"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "rest_id": restId,
    "restuarant_name": restuarantName,
    "rest_owner_name": restOwnerName,
    "rest_owner_pic": restOwnerPic,
    "phone": phone,
    "address": address,
    "state": state,
    "local_govt": localGovt,
    "landmark": landmark,
    "cover_pic": coverPic,
    "banner": banner,
    "descriptions": descriptions,
    "opening_hour": openingHour,
    "days": days,
    "email": email,
    "website": website,
    "social_handle": socialHandle,
    "rating": rating,
    "menu_pic": List<dynamic>.from(menuPic.map((x) => x)),
  };
}
