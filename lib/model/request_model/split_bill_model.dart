import 'dart:convert';

SplitBillModel splitBillFromJson(String str) =>
    SplitBillModel.fromJson(json.decode(str));

String splitBillToJson(SplitBillModel data) => json.encode(data.toJson());

class SplitBillModel {
  SplitBillModel({
    required this.reservId,
    required this.totalBill,
    required this.billSplit,
  });

  String reservId;
  String totalBill;
  List<BillSplit> billSplit;

  factory SplitBillModel.fromJson(Map<String, dynamic> json) => SplitBillModel(
        reservId: json["reservation_id"],
        totalBill: json["total_amount"],
        billSplit: List<BillSplit>.from(
            json["guests"].map((x) => BillSplit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "reservation_id": reservId,
        "total_amount": totalBill,
        "guests": List<dynamic>.from(billSplit.map((x) => x.toJson())),
      };
}

class BillSplit {
  BillSplit({
    required this.guestEmail,
    required this.guestName,
    required this.type,
    required this.insertBill,
  });

  String guestEmail;
  String guestName;
  String type;
  String insertBill;

  factory BillSplit.fromJson(Map<String, dynamic> json) => BillSplit(
        guestEmail: json["guest_email"],
        guestName: json["guest_name"],
        insertBill: json["bill"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "guest_email": guestEmail,
        "bill": insertBill,
        "type": type,
        "guest_name": guestName
      };
}
