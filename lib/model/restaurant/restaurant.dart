// To parse this JSON data, do
//
//     final resuarant = resuarantFromJson(jsonString);

import 'dart:convert';

Restaurant restaurantFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
  Restaurant({
    required this.status,
    required this.allRestDetail,
  });

  String status;
  List<RestaurantData> allRestDetail;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    status: json["status"],
    allRestDetail: List<RestaurantData>.from(json["all_rest_detail"].map((x) => RestaurantData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "all_rest_detail": List<dynamic>.from(allRestDetail.map((x) => x.toJson())),
  };
}

class RestaurantData {
  RestaurantData({
    required this.restId,
    required this.restuarantName,
    required this.address,
    required this.state,
    required this.localGovt,
    required this.landmark,
    required this.rating,
    required this.banner,
    required this.descriptions,
    required this.coverPic,
    required this.openingHour,
    required this.days,
    required this.email,
    required this.phone,
    required this.website,
    required this.socialHandle,
    required this.menuPic,
  });

  String restId;
  String restuarantName;
  String address;
  String state;
  String localGovt;
  String landmark;
  String rating;
  String banner;
  String descriptions;
  String coverPic;
  String openingHour;
  String days;
  String email;
  String phone;
  String website;
  String socialHandle;
  List<String> menuPic;

  factory RestaurantData.fromJson(Map<dynamic, dynamic> json) => RestaurantData(
    restId: json["rest_id"],
    restuarantName: json["restuarant_name"],
    address: json["address"],
    state: json["state"],
    localGovt: json["local_govt"],
    landmark: json["landmark"],
    rating: json["rating"],
    banner: json["banner"],
    descriptions: json["descriptions"],
    coverPic: json["cover_pic"],
    openingHour: json["opening_hour"],
    days: json["days"],
    email: json["email"],
    phone: json["phone"],
    website: json["website"],
    socialHandle: json["social_handle"],
    menuPic: List<String>.from(json["menu_pic"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "rest_id": restId,
    "restuarant_name": restuarantName,
    "address": address,
    "state": state,
    "local_govt": localGovt,
    "landmark": landmark,
    "rating": rating,
    "banner": banner,
    "descriptions": descriptions,
    "cover_pic": coverPic,
    "opening_hour": openingHour,
    "days": days,
    "email": email,
    "phone": phone,
    "website": website,
    "social_handle": socialHandle,
    "menu_pic": List<dynamic>.from(menuPic.map((x) => x)),
  };
}
