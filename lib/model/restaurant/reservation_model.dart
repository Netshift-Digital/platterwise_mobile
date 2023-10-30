// To parse this JSON data, do
//
//     final reservationList = reservationListFromJson(jsonString);

import 'dart:convert';

class UserReservation {
  UserReservation({
    required this.reservId,
    required this.profileUrl,
    required this.username,
    required this.restId,
    required this.seatType,
    required this.noOfGuest,
    required this.reservationDate,
    required this.reservationStatus,
    required this.guestInfo,
    required this.restDetail,
  });

  int reservId;
  String profileUrl;
  String username;
  int restId;
  String seatType;
  int noOfGuest;
  String reservationDate;
  int reservationStatus;
  List<GuestInfo> guestInfo;
  RestDetail restDetail;

  factory UserReservation.fromJson(Map<String, dynamic> json) =>
      UserReservation(
        reservId: json["id"] ?? 0,
        profileUrl: json["img_url"] ?? "",
        username: json["username"] ?? "",
        restId: json["restaurant_id"] ?? 0,
        seatType: json["seat_type"] ?? "",
        noOfGuest: json["guest_no"] ?? 1,
        reservationDate: json["reservation_date"] ?? "",
        reservationStatus: json["status"] ?? 1,
       guestInfo: (json["guests"] != null && json["guests"] != "null")
      ? List<GuestInfo>.from(
          (jsonDecode(json["guests"]) as List)
              .map((x) => GuestInfo.fromJson(x)),
        )
      : <GuestInfo>[],
        restDetail: RestDetail.fromJson(json["restaurant"]),
      );
}

class GuestInfo {
  GuestInfo(
      {required this.guestName, required this.guestEmail, this.amount = '0'});

  String guestName;
  String guestEmail;
  String amount;

  factory GuestInfo.fromJson(Map<String, dynamic> json) => GuestInfo(
        guestName: json["name"] ?? "",
        guestEmail: json["email"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": guestName,
        "email": guestEmail,
      };
}

class RestDetail {
  RestDetail({
    required this.restaurantName,
    required this.address,
    required this.coverPic,
  });

  String restaurantName;
  String address;
  String coverPic;

  factory RestDetail.fromJson(Map<String, dynamic> json) => RestDetail(
        restaurantName: json["name"] ?? "",
        address: json["address"] ?? "",
        coverPic: json["cover_pic"] ??
            "https://www.balmoraltanks.com/images/common/video-icon-image.jpg",
      );

  Map<String, dynamic> toJson() => {
        "name": restaurantName,
        "address": address,
        "cover_pic": coverPic,
      };
}
