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
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
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
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: model.userReservation.isEmpty
            ? const Center(
                child: EmptyContentContainer(
                  errorText: "Now reservation has been made",
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await model.getReservations();
                  return;
                },
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: model.userReservation.length,
                    itemBuilder: (context, index) {
                      var data = model.userReservation[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            nav(
                                context,
                                ReservationDetails(
                                  userReservation: data,
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 99.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.only(
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
                                      data.restDetail.coverPic,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data.restDetail.restaurantName,
                                              overflow: TextOverflow.clip,
                                              maxLines: 1,
                                              softWrap: true,
                                              style: AppTextTheme.h3.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    RandomFunction.reserveColor(
                                                  data.reservationStatus,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            RandomFunction.reserveString(
                                                data.reservationStatus),
                                            style: AppTextTheme.h5.copyWith(
                                              fontSize: 12,
                                              color:
                                                  RandomFunction.reserveColor(
                                                      data.reservationStatus),
                                            ),
                                            softWrap: true,
                                            maxLines: 3,
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
                      );
                    }),
              ),
      ),
    );
  }
}
