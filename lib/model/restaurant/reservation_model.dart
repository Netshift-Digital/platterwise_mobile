import 'dart:convert';

class UserReservation {
  UserReservation(
      {required this.reservId,
      required this.profileUrl,
      required this.username,
      required this.restId,
      required this.seatType,
      required this.noOfGuest,
      required this.reservationDate,
      required this.reservationStatus,
      required this.guestInfo,
      required this.allGuestInfo,
      required this.restDetail,
      required this.bill});

  int reservId;
  String profileUrl;
  String username;
  int restId;
  String seatType;
  int noOfGuest;
  String reservationDate;
  int reservationStatus;
  List<GuestInfo> guestInfo;
  List<GuestInfo> allGuestInfo;
  RestDetail restDetail;
  ReservationBill? bill;

  factory UserReservation.fromJson(Map<String, dynamic> json) =>
      UserReservation(
          reservId: json["id"] ?? 0,
          profileUrl: json["owner"]["profileUrl"] ?? "",
          username: json["owner"]["username"] ?? "",
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
          allGuestInfo:
              (json["all_guests"] != null && json["all_guests"] != "null")
                  ? List<GuestInfo>.from(
                      (jsonDecode(json["all_guests"]) as List)
                          .map((x) => GuestInfo.fromJson(x)),
                    )
                  : <GuestInfo>[],
          restDetail: RestDetail.fromJson(json["restaurant"]),
          bill: json["reservation_bill"] == null
              ? null
              : ReservationBill.fromJson(json["reservation_bill"]));
}

class GuestInfo {
  GuestInfo(
      {required this.guestName,
      required this.guestEmail,
      this.amount = '0',
      required this.type});

  String guestName;
  String guestEmail;
  String amount;
  String type;

  factory GuestInfo.fromJson(Map<String, dynamic> json) => GuestInfo(
      guestName: json["name"] ?? "",
      guestEmail: json["email"] ?? "",
      type: json["type"] ?? "");

  Map<String, dynamic> toJson() =>
      {"name": guestName, "email": guestEmail, "type": type};
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

class ReservationBill {
  String grandPrice = "";
  String amountPaid = "";
  String billPix = "";
  int? status;

  ReservationBill(
      {required this.grandPrice,
      required this.billPix,
      this.status,
      required this.amountPaid});

  ReservationBill.fromJson(Map<String, dynamic> json) {
    grandPrice =
        json['total_bill'] == null ? "0" : json['total_bill'].toString();
    billPix = json['set_picture'] ?? "";
    status = json['status'] ?? 0;
    amountPaid =
        json['amount_paid'] == null ? "0" : json['amount_paid'].toString();
  }
}

class SingleTransactionId {
  String authUrl = "";
  String accessCode = "";
  String ref = "";

  SingleTransactionId(
      {required this.authUrl, required this.accessCode, required this.ref});

  SingleTransactionId.fromJson(Map<String, dynamic> json) {
    authUrl = json['authorization_url'] ?? "";
    accessCode = json['access_code'] ?? "";
    ref = json['reference'] ?? "";
  }
}
