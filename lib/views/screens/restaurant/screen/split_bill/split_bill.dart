import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/reservation_bill.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';

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
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
               Container(
                 width: double.maxFinite,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(6),
                   color: AppColor.p200
                 ),
                 child: Column(
                   children: [
                    const SizedBox(height: 18,),
                     Text('Your Bill',style: AppTextTheme.h3.copyWith(
                         fontSize: 14,
                         fontWeight: FontWeight.w500,
                         color: Colors.white
                     ),),
                     const SizedBox(height: 8,),
                     Text(widget.reservationBillElement.grandPrice.toCurrency(),style: const TextStyle(
                         fontSize: 22,
                         fontWeight: FontWeight.w700,
                         color: Colors.white
                     ),),
                     const SizedBox(height: 17,),
                   ],
                 ),
               ),
              const SizedBox(height: 24,),
              Row(
                children: [
                  Text('Your are splitting: ',
                      style: AppTextTheme.h3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,

                      ),
                  ),
                  const SizedBox(height: 4,),
                  Row(
                    children: [
                      Text('Equally',
                        style: AppTextTheme.h3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColor.p200

                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: AppColor.p200,)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
