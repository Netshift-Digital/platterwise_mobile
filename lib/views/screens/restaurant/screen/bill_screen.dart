import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
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
  const BillScreen({
    Key? key,
    required this.userReservation,
    required this.reservationBill,
  }) : super(key: key);

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
                          height: 20,
                        ),
                        Expanded(
                          child: reservationBill.billPix == null
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    showImageViewer(
                                        context,
                                        CachedNetworkImageProvider(
                                          reservationBill.billPix ?? "",
                                        ),
                                        onViewerDismissed: () {},
                                        useSafeArea: true,
                                        swipeDismissible: true,
                                        immersive: true);
                                  },
                                  child: ImageCacheR(
                                      reservationBill.billPix ?? ''),
                                ),
                        ),
                        const Divider(),
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
                              reservationBill.grandPrice!.isEmpty?"0":(reservationBill.grandPrice ?? '0').toCurrency(),
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
                    child: PlatButton(
                        title: "Pay Entire Bill",
                        onTap: () {
                          PayStackPayment.makePayment(
                              num.parse(reservationBill.grandPrice ?? '0')
                                  .toInt(),
                              userReservation.reservId ?? "",
                              context).then((value){
                                if(value==true){
                                  Navigator.pop(context);
                                }
                          });
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
                        RandomFunction.sheet(
                            context,
                            SelectSplit(
                              getPaidGuest: () {
                                Navigator.pop(context, true);
                              },
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
