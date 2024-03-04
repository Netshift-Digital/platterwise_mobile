import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/bill_screen.dart';
import 'package:platterwave/views/screens/restaurant/screen/split_bill/paid_guest.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/dialog/alert_dialog.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ReservationDetails extends StatefulWidget {
  UserReservation? userReservation;
  final String? id;
  ReservationDetails({
    this.userReservation,
    super.key,
    this.id,
  }) : assert(
          (userReservation != null || id != null),
          "pass either id or UserReservation",
        );

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: widget.userReservation == null
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor.p200),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  var data = await context
                      .read<RestaurantViewModel>()
                      .getSingleReservation(
                          widget.userReservation!.reservId.toString());
                  if (data != null) {
                    if (mounted) {
                      setState(() {
                        widget.userReservation = data;
                      });
                    }
                    return;
                  }
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reservation Details',
                        style: AppTextTheme.h2,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.g40,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: ImageCacheCircle(
                              //Made changes here
                              widget.userReservation!.profileUrl,
                              height: 38,
                              width: 38,
                            ),
                            title: Text(widget.userReservation!.username),
                            subtitle: Text(
                              'Host ID: ${widget.userReservation!.restId}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.g40,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                            bottom: 15,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImageCacheR(
                                widget.userReservation!.restDetail.coverPic,
                                height: 70,
                                width: 70,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.userReservation!.restDetail
                                          .restaurantName,
                                      style: AppTextTheme.h3,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: true,
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person_outline_sharp,
                                          color: AppColor.g800,
                                          size: 15,
                                        ),
                                        Text(
                                          '${widget.userReservation!.noOfGuest} Guest',
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_sharp,
                                          color: AppColor.g800,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          RandomFunction.date(widget
                                                  .userReservation!
                                                  .reservationDate)
                                              .yMMMMEEEEdjm,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Reservation status: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            RandomFunction.reserveString(
                                widget.userReservation!.reservationStatus),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: RandomFunction.reserveColor(
                                    widget.userReservation!.reservationStatus)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.g40,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 15,
                            bottom: 15,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Reservation code',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  SelectableText(
                                    widget.userReservation!.code.isEmpty
                                        ? widget.userReservation!.reservId
                                            .toString()
                                        : widget.userReservation!.code,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 100,
                                child: BarcodeWidget(
                                  barcode: Barcode.code128(),
                                  color: Colors.black87,
                                  data: widget.userReservation!.reservId
                                      .toString(),
                                  style: const TextStyle(fontSize: 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      getButton(context),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget getButton(BuildContext context) {
    num amountPaid = 0;
    if (widget.userReservation!.bill != null) {
      amountPaid = num.parse(widget.userReservation!.bill!.amountPaid);
    }
    if (widget.userReservation!.reservationStatus == 4 ||
        widget.userReservation!.isSplitted == 1 ||
        amountPaid > 0) {
      return PlatButton(
        title: "View payment Status",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaidGuestScreen(
                      userReservation: widget.userReservation!))).then((value) {
            getDetails();
          });
        },
      );
    } else if (widget.userReservation!.reservationStatus == 0) {
      return const SizedBox();
    } else if (widget.userReservation!.reservationStatus == 1 ||
        widget.userReservation!.reservationStatus == 2) {
      return PlatButton(
          appState: context.watch<RestaurantViewModel>().appState,
          color: Colors.red,
          title: "Cancel Reservation",
          onTap: () {
            CustomAlert(
                context: context,
                title: "Cancel reservation",
                body: "Are you sure you want to cancel this reservation? ",
                onTap: () {
                  context
                      .read<RestaurantViewModel>()
                      .cancelReservation(
                          widget.userReservation!.reservId.toString())
                      .then((value) {
                    if (value) {
                      context
                          .read<RestaurantViewModel>()
                          .getReservations(postIndex: 1, restart: true);
                      Navigator.pop(context);
                    }
                  });
                }).show();
          });
    } else {
      return PlatButton(
          title: "Make payment",
          appState: context.watch<RestaurantViewModel>().appState,
          onTap: () {
            if (widget.userReservation?.bill == null) {
              RandomFunction.toast("Bill Not sent");
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillScreen(
                      userReservation: widget.userReservation!,
                    ),
                    settings: const RouteSettings(name: "userReservation"),
                  ));
            }
          });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDetails();
    });
  }

  getDetails() async {
    var data = await context.read<RestaurantViewModel>().getSingleReservation(
        widget.id ?? widget.userReservation!.reservId.toString());
    if (data != null) {
      if (mounted) {
        setState(() {
          widget.userReservation = data;
        });
      }
    }
  }
}
