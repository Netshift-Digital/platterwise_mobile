import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:platterwave/model/restaurant/reservation_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/bill_screen.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/dialog/alert_dialog.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ReservationDetails extends StatefulWidget {
   UserReservation userReservation;
  ReservationDetails(this.userReservation, {Key? key}) : super(key: key);

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: ()async{
            var data = await  context.read<RestaurantViewModel>().getSingleReservation(widget.userReservation.reservId);
            if(data!=null){
              if(mounted){
                setState(() {
                  widget.userReservation=data;
                });
              }
              return;
            }
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
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
                        widget.userReservation.profileUrl,
                        height: 38,
                        width: 38,
                      ),
                      title: Text(widget.userReservation.username),
                      subtitle: const Text('Host ID: 5431678912'),
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
                          widget.userReservation.restDetail.first.coverPic,
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
                                widget.userReservation.restDetail.first.restaurantName,
                                style: AppTextTheme.h3,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: true,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline_sharp,
                                    color: AppColor.g800,
                                    size: 15,
                                  ),
                                  Text(
                                    '${widget.userReservation.noOfGuest} Guest',
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
                                    RandomFunction.date(
                                            widget.userReservation.reservationDate)
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
                      widget.userReservation.reservationStatus.capitalizeFirstChar(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: RandomFunction.reserveColor(
                              widget.userReservation.reservationStatus.toLowerCase())),
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
                            Text(
                              widget.userReservation.reservId,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        SizedBox(
                          height: 100,
                          child: BarcodeWidget(
                            barcode: Barcode.code128(),
                            color: Colors.black87,
                            data: widget.userReservation.reservId,
                            style: const TextStyle(fontSize: 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60,),
                !widget.userReservation.reservationStatus.toLowerCase().contains("inpr")?
                PlatButton(
                    appState: context.watch<RestaurantViewModel>().appState,
                    color: Colors.red,
                    title: "Cancel Reservation",
                    onTap: (){
                      CustomAlert(
                          context: context,
                          title: "Cancel reservation",
                          body: "Are you sure you want to cancel this reservation? ",
                          onTap: (){
                            context.read<RestaurantViewModel>().cancelReservation(widget.userReservation.reservId)
                            .then((value){
                              if(value){
                                Navigator.pop(context);
                              }
                            });

                          }
                      ).show();
                    }
                ) :PlatButton(
                    title: "Make payment",
                     appState: context.watch<RestaurantViewModel>().appState,
                    onTap: (){
                      context.read<RestaurantViewModel>().getReservationBill(widget.userReservation.reservId).
                          then((value){
                            if(value!=null){
                              nav(context, BillScreen(userReservation: widget.userReservation,reservationBillElement: value,));
                            }else{
                              RandomFunction.toast("Bill not ready");
                            }
                      });

                    },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}