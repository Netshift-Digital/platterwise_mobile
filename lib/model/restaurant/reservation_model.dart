// To parse this JSON data, do
//
//     final reservationList = reservationListFromJson(jsonString);

import 'dart:convert';

ReservationList reservationListFromJson(String str) => ReservationList.fromJson(json.decode(str));

String reservationListToJson(ReservationList data) => json.encode(data.toJson());

class ReservationList {
  ReservationList({
    required this.status,
    required this.userReservation,
  });

  String status;
  List<UserReservation> userReservation;

  factory ReservationList.fromJson(Map<dynamic, dynamic> json) => ReservationList(
    status: json["status"],
    userReservation: List<UserReservation>.from(json["user_reservation"].map((x) => UserReservation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user_reservation": List<dynamic>.from(userReservation.map((x) => x.toJson())),
  };
}

class UserReservation {
  UserReservation({
    required this.reservId,
    required this.fullName,
    required this.username,
    required this.profileBanned,
    required this.profileUrl,
    required this.restId,
    required this.seatType,
    required this.noOfGuest,
    required this.reservationDate,
    required this.reservationStatus,
    required this.guestInfo,
    required this.restDetail,
  });

  String reservId;
  String fullName;
  String username;
  String profileBanned;
  String profileUrl;
  String restId;
  String seatType;
  String noOfGuest;
  String reservationDate;
  String reservationStatus;
  List<GuestInfo> guestInfo;
  List<RestDetail> restDetail;

  factory UserReservation.fromJson(Map<String, dynamic> json) => UserReservation(
    reservId: json["reserv_id"],
    fullName: json["full_name"],
    username: json["username"],
    profileBanned: json["profile_banned"],
    profileUrl: json["profileUrl"],
    restId: json["rest_id"],
    seatType: json["seat_type"],
    noOfGuest: json["no_of_guest"],
    reservationDate: json["reservation_date"],
    reservationStatus: json["reservation_status"],
    guestInfo: List<GuestInfo>.from(json["guest_info"].map((x) => GuestInfo.fromJson(x))),
    restDetail: List<RestDetail>.from(json["rest_detail"].map((x) => RestDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "reserv_id": reservId,
    "full_name": fullName,
    "username": username,
    "profile_banned": profileBanned,
    "profileUrl": profileUrl,
    "rest_id": restId,
    "seat_type": seatType,
    "no_of_guest": noOfGuest,
    "reservation_date": reservationDate,
    "reservation_status": reservationStatus,
    "guest_info": List<dynamic>.from(guestInfo.map((x) => x.toJson())),
    "rest_detail": List<dynamic>.from(restDetail.map((x) => x.toJson())),
  };
}

class GuestInfo {
  GuestInfo({
    required this.guestName,
    required this.guestEmail,
  });

  String guestName;
  String guestEmail;

  factory GuestInfo.fromJson(Map<String, dynamic> json) => GuestInfo(
    guestName: json["guest_name"]??"",
    guestEmail: json["guest_email"]??"",
  );

  Map<String, dynamic> toJson() => {
    "guest_name": guestName,
    "guest_email": guestEmail,
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
    restaurantName: json["restaurant_name"],
    address: json["address"],
    coverPic: json["cover_pic"],
  );

  Map<String, dynamic> toJson() => {
    "restaurant_name": restaurantName,
    "address": address,
    "cover_pic": coverPic,
  };
}
