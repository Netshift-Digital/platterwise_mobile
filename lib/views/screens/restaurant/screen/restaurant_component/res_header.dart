import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/dynamic_link.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantHeader extends StatelessWidget {
  final RestaurantData restaurantData;
  final List<AllRestReview> review;
  const RestaurantHeader({
    Key? key,
    required this.restaurantData,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                restaurantData.restuarantName.capitalizeFirstChar(),
                style: AppTextTheme.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  DynamicLink.createLinkRestaurant(restaurantData)
                      .then((value) {
                    if (value != null) {
                      Share.share(value);
                    }
                  });
                },
                child: SvgPicture.asset(
                  'assets/icon/route-share.svg',
                  color: AppColor.g900,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  launchUrl(
                    Uri.parse("tel:${restaurantData.phone}"),
                  );
                },
                child: SvgPicture.asset(
                  'assets/icon/route-square.svg',
                  color: AppColor.g900,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  MapsLauncher.launchQuery(restaurantData.address);
                },
                child: SvgPicture.asset(
                  'assets/icon/route2.svg',
                  color: AppColor.g900,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                restaurantData.days.capitalizeFirstChar(),
                style: const TextStyle(
                  color: AppColor.g800,
                  fontSize: 13,
                ),
              )),
          const SizedBox(
            height: 7,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/icon/star.svg'),
              const SizedBox(
                width: 8,
              ),
              Text(
                restaurantData.rating?.toString() ?? "4.2",
                style: const TextStyle(fontSize: 12, color: AppColor.g700),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '(${review.length} reviews)',
                style: const TextStyle(
                  color: AppColor.g100,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/icon/location.svg'),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  restaurantData.address,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.g800),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
