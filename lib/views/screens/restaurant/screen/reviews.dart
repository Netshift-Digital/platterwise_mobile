import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/rate_experience_screen.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RestaurantsReviews extends StatefulWidget {
  List<AllRestReview> review;
  final RestaurantData restaurantData;
  RestaurantsReviews(
      {Key? key, required this.review, required this.restaurantData})
      : super(key: key);

  @override
  State<RestaurantsReviews> createState() => _RestaurantsReviewsState();
}

class _RestaurantsReviewsState extends State<RestaurantsReviews> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // var user = context.read<UserViewModel>().user;
    // var resViewModel = context.read<RestaurantViewModel>();
    // var size = MediaQuery.of(context).size;
    return widget.review.isEmpty
        ? Column(
            children: [
              EmptyContentContainer(),
            ],
          )
        : ListView.builder(
            itemCount: widget.review.length,
            padding: const EdgeInsets.only(bottom: 200),
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              var data = widget.review[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.g20,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ImageCacheCircle(
                              data.profileUrl,
                              height: 32,
                              width: 32,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              data.fullName,
                              style: AppTextTheme.h3.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 14.sp),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: (data.rating).toDouble(),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 18.0,
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              RandomFunction.timeAgo(data.timestamp),
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(data.review),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
