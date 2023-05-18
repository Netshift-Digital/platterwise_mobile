import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/reservation_bill.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:platterwave/utils/paystack.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/views/screens/restaurant/screen/split_bill/select_split.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class BillScreen extends StatelessWidget {
  final UserReservation userReservation;
  final ReservationBill reservationBill;
  const BillScreen(
      {Key? key,
      required this.userReservation,
      required this.reservationBill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Your Bill',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageCacheCircle(
                              userReservation.restDetail.first.coverPic,
                              height: 32,
                              width: 32,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              userReservation.restDetail.first.restaurantName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          RandomFunction.date(userReservation.reservationDate)
                              .yMMMMEEEEdjm,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColor.g300,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            Text(
                              "Descriptions",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Prices",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(color: Colors.red,),
                        ),
                        const Divider(),
                        Row(
                          children: const [
                            Text(
                              "VAT",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text(
                              "N30",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Total Payment ",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            Text(
                              (reservationBill.grandPrice??'0').toCurrency(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Thank you!",
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: PlatButton(title: "Pay Entire Bill", onTap: () {
                      PayStackPayment.investmentPlanPayment(
                      num.parse(reservationBill.grandPrice??'0').toInt(),
                      reservationBill.restId??"", context);
                    }),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: PlatButton(
                        title: "Split Bill",
                        color: AppColor.g100,
                        onTap: () {
                          RandomFunction.sheet(context, SelectSplit(
                            userReservation: userReservation,
                            reservationBill: reservationBill,
                          ));
                        },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
