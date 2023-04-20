// To parse this JSON data, do
//
//     final splitBill = splitBillFromJson(jsonString);

import 'dart:convert';

SplitBillModel splitBillFromJson(String str) => SplitBillModel.fromJson(json.decode(str));

String splitBillToJson(SplitBillModel data) => json.encode(data.toJson());

class SplitBillModel {
  SplitBillModel({
    required this.firebaseAuthId,
    required this.reservId,
    required this.ownerBill,
    required this.billSplit,
  });

  String firebaseAuthId;
  int reservId;
  num ownerBill;
  List<BillSplit> billSplit;

  factory SplitBillModel.fromJson(Map<String, dynamic> json) => SplitBillModel(
    firebaseAuthId: json["firebaseAuthID"],
    reservId: json["reserv_id"],
    ownerBill: json["owner_bill"],
    billSplit: List<BillSplit>.from(json["bill_split"].map((x) => BillSplit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "firebaseAuthID": firebaseAuthId,
    "reserv_id": reservId,
    "owner_bill": ownerBill,
    "bill_split": List<dynamic>.from(billSplit.map((x) => x.toJson())),
  };
}

class BillSplit {
  BillSplit({
    required this.guestEmail,
    required this.insertBill,
  });

  String guestEmail;
  num insertBill;

  factory BillSplit.fromJson(Map<String, dynamic> json) => BillSplit(
    guestEmail: json["guest_email"],
    insertBill: json["insert_bill"],
  );

  Map<String, dynamic> toJson() => {
    "guest_email": guestEmail,
    "insert_bill": insertBill,
  };
}
