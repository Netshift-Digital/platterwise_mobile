import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/split_bill/select_split.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';

import 'single_payment_screen.dart';

class BillScreen extends StatelessWidget {
  final UserReservation userReservation;
  const BillScreen({
    Key? key,
    required this.userReservation,
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
                              userReservation.restDetail.coverPic,
                              height: 32,
                              width: 32,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              userReservation.restDetail.restaurantName,
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
                          child: userReservation.bill?.billPix == null
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    showImageViewer(
                                        context,
                                        CachedNetworkImageProvider(
                                          userReservation.bill!.billPix,
                                        ),
                                        onViewerDismissed: () {},
                                        useSafeArea: true,
                                        swipeDismissible: true,
                                        immersive: true);
                                  },
                                  child: ImageCacheR(
                                      userReservation.bill!.billPix),
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
                              userReservation.bill!.grandPrice.isEmpty
                                  ? "0"
                                  : (userReservation.bill!.grandPrice)
                                      .toCurrency(),
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
              userReservation.allGuestInfo.length == 1
                  ? PlatButton(
                      appState: context.watch<RestaurantViewModel>().appState,
                      title: "Pay Entire Bill",
                      onTap: () {
                        context
                            .read<RestaurantViewModel>()
                            .getTransactionID(userReservation)
                            .then((value) {
                          if (value != null) {
                            context
                                .read<RestaurantViewModel>()
                                .setState(AppState.idle);
                            nav(
                                context,
                                SinglePaymentScreen(
                                  txn: value,
                                  reservId: userReservation.reservId.toString(),
                                ));
                          }
                        });
                      })
                  : Row(
                      children: [
                        Expanded(
                          child: PlatButton(
                              appState:
                                  context.watch<RestaurantViewModel>().appState,
                              title: "Pay Entire Bill",
                              onTap: () {
                                context
                                    .read<RestaurantViewModel>()
                                    .getTransactionID(userReservation)
                                    .then((value) {
                                  if (value != null) {
                                    context
                                        .read<RestaurantViewModel>()
                                        .setState(AppState.idle);
                                    nav(
                                        context,
                                        SinglePaymentScreen(
                                          txn: value,
                                          reservId: userReservation.reservId
                                              .toString(),
                                        ));
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
