


class ReservationBillElement {
  String? status;
  List<ReservationBill>? reservationBill;

  ReservationBillElement({this.status, this.reservationBill});

  ReservationBillElement.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['reservation_bill'] != null) {
      reservationBill = <ReservationBill>[];
      json['reservation_bill'].forEach((v) {
        reservationBill!.add(new ReservationBill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.reservationBill != null) {
      data['reservation_bill'] =
          this.reservationBill!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReservationBill {
  String? fullName;
  String? username;
  String? firebaseAuthID;
  String? profileBanned;
  String? profileUrl;
  String? restId;
  String? seatType;
  String? noOfGuest;
  String? reservationDate;
  dynamic itemOrdered;
  String? grandPrice;
  String? billPix;
  dynamic transactionId;

  ReservationBill(
      {this.fullName,
        this.username,
        this.firebaseAuthID,
        this.profileBanned,
        this.profileUrl,
        this.restId,
        this.seatType,
        this.noOfGuest,
        this.reservationDate,
        this.itemOrdered,
        this.grandPrice,
        this.billPix,
        this.transactionId});

  ReservationBill.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    username = json['username'];
    firebaseAuthID = json['firebaseAuthID'];
    profileBanned = json['profile_banned'];
    profileUrl = json['profileUrl'];
    restId = json['rest_id'];
    seatType = json['seat_type'];
    noOfGuest = json['no_of_guest'];
    reservationDate = json['reservation_date'];
    itemOrdered = json['item_ordered'];
    grandPrice = json['grand_price'];
    billPix = json['bill_pix'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['username'] = this.username;
    data['firebaseAuthID'] = this.firebaseAuthID;
    data['profile_banned'] = this.profileBanned;
    data['profileUrl'] = this.profileUrl;
    data['rest_id'] = this.restId;
    data['seat_type'] = this.seatType;
    data['no_of_guest'] = this.noOfGuest;
    data['reservation_date'] = this.reservationDate;
    data['item_ordered'] = this.itemOrdered;
    data['grand_price'] = this.grandPrice;
    data['bill_pix'] = this.billPix;
    data['transactionId'] = this.transactionId;
    return data;
  }
}

