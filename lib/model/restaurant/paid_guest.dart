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
        allPaidList: List<AllPaidList>.from(
            json["all_paid_list"].map((x) => AllPaidList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "all_paid_list": List<dynamic>.from(allPaidList.map((x) => x.toJson())),
      };
}

class AllPaidList {
  String transactionId;
  int reservId;
  String guestName;
  String guestEmail;
  num totalBill;
  String modeOfPayment;
  String channel;
  int status;

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
        transactionId: json["payment_ref"] ?? "",
        reservId: json["reservation_id"] ?? 0,
        guestName: json["guest_name"] ?? "",
        guestEmail: json["email"] ?? "",
        totalBill: json["amount_paid"] != null ? json["amount_paid"] / 100 : 0,
        modeOfPayment: json["payment_type"] ?? "",
        channel: json["channel"] ?? "",
        status: json["status"] ?? 2,
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
