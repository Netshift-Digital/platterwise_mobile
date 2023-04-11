import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/reservation_bill.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';

class SplitBill extends StatefulWidget {
  final UserReservation userReservation;
  final ReservationBillElement reservationBillElement;
  final List<GuestInfo> guestInfo;
  const SplitBill({Key? key, required this.userReservation, required this.reservationBillElement, required this.guestInfo}) : super(key: key);

  @override
  State<SplitBill> createState() => _SplitBillState();
}

class _SplitBillState extends State<SplitBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
