// To parse this JSON data, do
//
//     final reservationBill = reservationBillFromJson(jsonString);

import 'dart:convert';

ReservationBill reservationBillFromJson(String str) => ReservationBill.fromJson(json.decode(str));

String reservationBillToJson(ReservationBill data) => json.encode(data.toJson());

class ReservationBill {
  ReservationBill({
    required this.status,
    required this.reservationBill,
  });

  String status;
  List<ReservationBillElement> reservationBill;

  factory ReservationBill.fromJson(Map<String, dynamic> json) => ReservationBill(
    status: json["status"],
    reservationBill: List<ReservationBillElement>.from(json["reservation_bill"].map((x) => ReservationBillElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "reservation_bill": List<dynamic>.from(reservationBill.map((x) => x.toJson())),
  };
}

class ReservationBillElement {
  ReservationBillElement({
    required this.fullName,
    this.username,
    required this.firebaseAuthId,
    required this.profileBanned,
    required this.profileUrl,
    required this.restId,
    required this.seatType,
    required this.noOfGuest,
    required this.reservationDate,
    required this.itemOrdered,
    required this.grandPrice,
    this.transactionId,
  });

  String fullName;
  dynamic username;
  String firebaseAuthId;
  String profileBanned;
  String profileUrl;
  String restId;
  String seatType;
  String noOfGuest;
  String reservationDate;
  List<ItemOrdered> itemOrdered;
  String grandPrice;
  dynamic transactionId;

  factory ReservationBillElement.fromJson(Map<String, dynamic> json) => ReservationBillElement(
    fullName: json["full_name"],
    username: json["username"],
    firebaseAuthId: json["firebaseAuthID"],
    profileBanned: json["profile_banned"],
    profileUrl: json["profileUrl"],
    restId: json["rest_id"],
    seatType: json["seat_type"],
    noOfGuest: json["no_of_guest"],
    reservationDate: json["reservation_date"],
    itemOrdered: List<ItemOrdered>.from(json["item_ordered"].map((x) => ItemOrdered.fromJson(x))),
    grandPrice: json["grand_price"],
    transactionId: json["transactionId"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "username": username,
    "firebaseAuthID": firebaseAuthId,
    "profile_banned": profileBanned,
    "profileUrl": profileUrl,
    "rest_id": restId,
    "seat_type": seatType,
    "no_of_guest": noOfGuest,
    "reservation_date": reservationDate,
    "item_ordered": List<dynamic>.from(itemOrdered.map((x) => x.toJson())),
    "grand_price": grandPrice,
    "transactionId": transactionId,
  };
}

class ItemOrdered {
  ItemOrdered({
    required this.orderId,
    required this.item,
    required this.unitPrice,
    required this.qty,
    required this.totalPrice,
  });

  String orderId;
  String item;
  String unitPrice;
  String qty;
  String totalPrice;

  factory ItemOrdered.fromJson(Map<String, dynamic> json) => ItemOrdered(
    orderId: json["order_id"],
    item: json["item"],
    unitPrice: json["unit_price"],
    qty: json["qty"],
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "item": item,
    "unit_price": unitPrice,
    "qty": qty,
    "total_price": totalPrice,
  };
}
