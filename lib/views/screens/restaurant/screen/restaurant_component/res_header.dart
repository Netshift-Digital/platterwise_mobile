import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/dynamic_link.dart';
import 'package:platterwave/utils/extension.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantHeader extends StatefulWidget {
  final RestaurantData restaurantData;
  final List<AllRestReview> review;

  RestaurantHeader({
    Key? key,
    required this.restaurantData,
    required this.review,
  }) : super(key: key);

  @override
  State<RestaurantHeader> createState() => _RestaurantHeaderState();
}

class _RestaurantHeaderState extends State<RestaurantHeader> {
  @override
  Widget build(BuildContext context) {
    String openingTime = parseTimeString(widget.restaurantData.openingHour);
    String closingTime = parseTimeString(widget.restaurantData.closingHour);
    print("This is the closing date $closingTime");
    print("This is the opening date $openingTime");
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
                widget.restaurantData.restuarantName.capitalizeFirstChar(),
                style: AppTextTheme.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  DynamicLink.createLinkRestaurant(widget.restaurantData)
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
                    Uri.parse("tel:${widget.restaurantData.phone}"),
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
                  MapsLauncher.launchQuery(widget.restaurantData.address);
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
          Row(
            children: [
              SvgPicture.asset('assets/icon/location.svg'),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  widget.restaurantData.address,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.g800),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/icon/star.svg'),
              const SizedBox(
                width: 8,
              ),
              Text(
                getAverageRating(),
                style: const TextStyle(fontSize: 12, color: AppColor.g700),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '(${widget.review.length} reviews)',
                style: const TextStyle(
                  color: AppColor.g100,
                  fontSize: 12,
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
                widget.restaurantData.days.isEmpty
                    ? "Opens: $openingTime - $closingTime"
                    : "Opens: ${widget.restaurantData.days.capitalizeFirstChar()}, $openingTime - $closingTime",
                style: const TextStyle(
                  color: AppColor.g800,
                  fontSize: 13,
                ),
              )),
          const SizedBox(
            height: 12,
          ),
          /* Consumer<RestaurantViewModel>(
            builder: (context, restaurantViewModel, child) {
              return GestureDetector(
                onTap: () {
                  if (widget.restaurantData.isFollowed == true) {
                    resModel.unfollowRestaurant(widget.restaurantData);
                    setState(() {
                      widget.restaurantData.isFollowed = false;
                    });
                  } else {
                    resModel.followRestaurant(widget.restaurantData);
                    setState(() {
                      widget.restaurantData.isFollowed = true;
                    });
                  }
                },
                child: widget.restaurantData.isFollowed == true
                    ? PlatButtonBorder(
                        title: "Followed",
                        padding: 0,
                        textSize: 14,
                        color: AppColor.g500,
                        textColor: AppColor.g500,
                        height: 48.h,
                      )
                    : PlatButtonBorder(
                        title: "Follow Restaurant",
                        padding: 0,
                        height: 48.h,
                        textSize: 14,
                      ),
              );
            },
          ),*/
        ],
      ),
    );
  }

  String getAverageRating() {
    if (widget.restaurantData.rating == null ||
        widget.restaurantData.rating is! num ||
        widget.review.isEmpty) {
      return '0';
    }
    double averageRating = widget.restaurantData.rating / widget.review.length;
    return averageRating.toStringAsFixed(1);
  }

  String parseTimeString(String dateTimeString) {
    DateFormat inputFormat = DateFormat("h:mm:ssaZZZ");
    DateTime dateTime = inputFormat.parse(dateTimeString);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }
}
