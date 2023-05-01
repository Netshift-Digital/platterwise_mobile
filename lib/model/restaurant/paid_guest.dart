// To parse this JSON data, do
//
//     final paidGuest = paidGuestFromJson(jsonString);

import 'dart:convert';

PaidGuest paidGuestFromJson(String str) => PaidGuest.fromJson(json.decode(str));

String paidGuestToJson(PaidGuest data) => json.encode(data.toJson());

class PaidGuest {
  String status;
  List<AllPaidList> allPaidList;

  PaidGuest({
    required this.status,
    required this.allPaidList,
  });

  factory PaidGuest.fromJson(Map<String, dynamic> json) => PaidGuest(
    status: json["status"],
    allPaidList: List<AllPaidList>.from(json["all_paid_list"].map((x) => AllPaidList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "all_paid_list": List<dynamic>.from(allPaidList.map((x) => x.toJson())),
  };
}

class AllPaidList {
  String transactionId;
  String reservId;
  String guestName;
  String guestEmail;
  String totalBill;
  String modeOfPayment;
  String channel;
  String status;

  AllPaidList({
    required this.transactionId,
    required this.reservId,
    required this.guestName,
    required this.guestEmail,
    required this.totalBill,
    required this.modeOfPayment,
    required this.channel,
    required this.status,
  });

  factory AllPaidList.fromJson(Map<String, dynamic> json) => AllPaidList(
    transactionId: json["transactionId"],
    reservId: json["reserv_id"],
    guestName: json["guest_name"],
    guestEmail: json["guest_email"],
    totalBill: json["total_bill"],
    modeOfPayment: json["mode_of_payment"],
    channel: json["channel"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "reserv_id": reservId,
    "guest_name": guestName,
    "guest_email": guestEmail,
    "total_bill": totalBill,
    "mode_of_payment": modeOfPayment,
    "channel": channel,
    "status": status,
  };
}
