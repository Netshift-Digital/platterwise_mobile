import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/make_reservation_screen.dart';
import 'package:platterwave/views/screens/restaurant/screen/rate_experience_screen.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';

class RestaurantBottom extends StatelessWidget {
  final int index;
  final RestaurantData restaurantData;
  final Function(RestaurantData review) onReview;
  const RestaurantBottom({
    Key? key,
    required this.restaurantData,
    required this.index,
    required this.onReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = context.read<UserViewModel>().user;
    return index == 0
        ? Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 35, top: 20),
            child: PlatButton(
              title: 'Make Reservation',
              onTap: () {
                nav(
                  context,
                  MakeReservationScreen(
                    restaurantData: restaurantData,
                  ),
                );
              },
            ),
          )
        : GestureDetector(
            onTap: () async {
              var data = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RateExperienceScreen(
                          restaurantData: restaurantData)));
              if (data != null) {
                onReview(data);
              }
            },
            child: PhysicalModel(
              color: Colors.black,
              elevation: 0,
              child: Container(
                height: 125,
                width: size.width,
                color: Colors.white,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        ImageCacheCircle(
                          user == null ? "" : user.profileUrl,
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Expanded(
                            child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add a comment ",
                              filled: true,
                              fillColor: AppColor.g30),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
