import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

var placeText =
    "I recently dined at De Place Restaurant and was blown away by the quality of the food and the service. The menu had a great selection of dishes, and I was impressed by the use of fresh ingredients in every dish.";

class RestaurantsReviews extends StatelessWidget {
  final List<AllRestReview> review;
  const RestaurantsReviews({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: review.length,
        primary: false,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var data = review[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                          rating: (num.tryParse(data.rating)??0).toDouble(),
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
        });
  }
}
