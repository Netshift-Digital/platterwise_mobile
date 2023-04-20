import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/reservation_details.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/dialog/alert_dialog.dart';
import 'package:provider/provider.dart';

class UserReservations extends StatelessWidget {
  const UserReservations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = context.watch<RestaurantViewModel>();
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
           physics: const BouncingScrollPhysics(),
            itemCount: model.userReservation.length,
            itemBuilder: (context, index) {
              var data = model.userReservation[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    nav(context, ReservationDetails(data));
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColor.g0),
                      child: Row(
                        children: [
                          Container(
                            width: 99.w,
                            height: 100.h,
                            decoration: const BoxDecoration(
                              color: AppColor.p300,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                              ),
                              child: ImageCacheR(
                               data.restDetail.isEmpty?"":data.restDetail.first.coverPic,
                              topRadius: 0,
                                topBottom: 0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                       data.restDetail.isEmpty?"https://www.balmoraltanks.com/images/common/video-icon-image.jpg":data.restDetail.first.restaurantName,
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        softWrap: true,
                                        style: AppTextTheme.h3.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    PopupMenuButton<int>(
                                      onSelected: (e) {
                                        if (e == 0) {
                                          nav(context,
                                              ReservationDetails(data));
                                        } else if (e == 3) {
                                          CustomAlert(
                                              context: context,
                                              title: "Cancel reservation",
                                              body:
                                                  "Are you sure you want to cancel this reservation? ",
                                              onTap: () {
                                                context
                                                    .read<RestaurantViewModel>()
                                                    .cancelReservation(
                                                        data.reservId);
                                              }).show();
                                        }
                                      },
                                      itemBuilder: (ctx) => [
                                        PopupMenuItem(
                                          value: 0,
                                          onTap: () {},
                                          child: Row(
                                            children: const [
                                              Icon(Icons.visibility),
                                              SizedBox(
                                                // sized box with width 10
                                                width: 10,
                                              ),
                                              Text("view")
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 3,
                                          onTap: () {},
                                          // row has two child icon and text
                                          child: Row(
                                            children: const [
                                              Icon(Icons.clear),
                                              SizedBox(
                                                // sized box with width 10
                                                width: 10,
                                              ),
                                              Text("Cancel reservation")
                                            ],
                                          ),
                                        )
                                      ],
                                      // offset:const Offset(0, 100),
                                      // color: Colors.grey,
                                      elevation: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: RandomFunction.reserveColor(
                                                  data.reservationStatus
                                                      .toLowerCase())
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          ' Reservation ${data.reservationStatus.capitalizeFirstChar()} ',
                                          style: AppTextTheme.h5.copyWith(
                                            fontSize: 12,
                                            color: RandomFunction.reserveColor(
                                                data.reservationStatus
                                                    .toLowerCase()),
                                          ),
                                          softWrap: true,
                                          maxLines: 3,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}