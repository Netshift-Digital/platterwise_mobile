// To parse this JSON data, do
//
//     final reservationData = reservationDataFromJson(jsonString);

import 'dart:convert';

ReservationData reservationDataFromJson(String str) => ReservationData.fromJson(json.decode(str));

String reservationDataToJson(ReservationData data) => json.encode(data.toJson());

class ReservationData {
  ReservationData({
    required this.firebaseAuthId,
    required this.reservationDate,
    required this.restId,
    required this.sitType,
    required this.guestNo,
    required this.guest,
  });

  String firebaseAuthId;
  String reservationDate;
  String restId;
  String sitType;
  String guestNo;
  List<Guest> guest;

  factory ReservationData.fromJson(Map<String, dynamic> json) => ReservationData(
    firebaseAuthId: json["firebaseAuthID"],
    reservationDate: json["reservation_date"],
    restId: json["rest_id"],
    sitType: json["sit_type"],
    guestNo: json["guest_no"],
    guest: List<Guest>.from(json["guest"].map((x) => Guest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "firebaseAuthID": firebaseAuthId,
    "reservation_date": reservationDate,
    "rest_id": restId,
    "sit_type": sitType,
    "guest_no": guestNo,
    "guest": List<dynamic>.from(guest.map((x) => x.toJson())),
  };
}

class Guest {
  Guest({
    required this.guestName,
    required this.guestEmail,
    this.profilePic = 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png'
  });

  String guestName;
  String guestEmail;
  String profilePic;

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    guestName: json["guest_name"],
    guestEmail: json["guest_email"],
  );

  Map<String, dynamic> toJson() => {
    "guest_name": guestName,
    "guest_email": guestEmail,
  };
}
