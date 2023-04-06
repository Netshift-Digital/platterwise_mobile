import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/make_reservation_screen.dart';
import 'package:platterwave/views/screens/restaurant/screen/reviews.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetails extends StatefulWidget {
  final RestaurantData restaurantData;
  const RestaurantDetails({Key? key, required this.restaurantData})
      : super(key: key);

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  int index = 0;
  PageController pageController = PageController();
  List<AllRestReview> review = [];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SlidingUpPanel(
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        minHeight: 130,
        maxHeight: size.height - 200,
        panel: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.restaurantData.restuarantName,
                      style: AppTextTheme.h3
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        launchUrl(
                            Uri.parse("tel:${widget.restaurantData.phone}"));
                      },
                      child: SvgPicture.asset('assets/icon/route-square.svg'),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                        onTap: () {
                          MapsLauncher.launchQuery(
                              widget.restaurantData.address);
                        },
                        child: SvgPicture.asset('assets/icon/route2.svg')),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icon/star.svg'),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text('4.2'),
                    const SizedBox(
                      width: 8,
                    ),
                     Text(
                      '(${review.length} reviews)',
                      style: const TextStyle(color: AppColor.g100),
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
                        widget.restaurantData.address,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   index=0;
                        // });
                        pageController.animateToPage(0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Column(
                        children: [
                          Text(
                            "Details",
                            style: AppTextTheme.h3.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: index != 0 ? AppColor.g100 : null),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          index != 0
                              ? const SizedBox()
                              : Container(
                                  height: 1,
                                  width: 32,
                                  color: AppColor.p200,
                                )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   index=1;
                        // });
                        pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: Column(
                        children: [
                          Text(
                            "Reviews",
                            style: AppTextTheme.h3.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: index != 1 ? AppColor.g100 : null),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          index != 1
                              ? const SizedBox()
                              : Container(
                                  height: 1,
                                  width: 32,
                                  color: AppColor.p200,
                                )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                    child: PageView(
                  controller: pageController,
                  onPageChanged: (e) {
                    if (index != e) {
                      setState(() {
                        index = e;
                      });
                    }
                  },
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReadMoreText(
                          widget.restaurantData.descriptions,
                          style: AppTextTheme.h3.copyWith(fontSize: 16),
                          moreStyle: AppTextTheme.h3
                              .copyWith(fontSize: 14, color: AppColor.p200),
                          lessStyle: AppTextTheme.h3
                              .copyWith(fontSize: 14, color: AppColor.p200),
                        ),
                        const SizedBox(
                          height: 33,
                        ),
                        Text(
                          'Photos',
                          style: AppTextTheme.h3.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount:widget.restaurantData.menuPix.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return  Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  height: 80,
                                  width: 111,
                                  child: GestureDetector(
                                    onTap: (){
                                      showImageViewer(
                                          context,
                                          CachedNetworkImageProvider(widget.restaurantData.menuPix[index].menuPic),
                                          onViewerDismissed: () {
                                          },
                                          useSafeArea: true,
                                          swipeDismissible: true
                                      );
                                    },
                                      child: ImageCacheR(widget.restaurantData.menuPix[index].menuPic),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 93,
                        ),
                        PlatButton(
                            title: 'Make Reservation',
                            onTap: () {
                              nav(
                                  context,
                                  MakeReservationScreen(
                                    restaurantData: widget.restaurantData,
                                  ));
                            },
                        )
                      ],
                    ),
                    RestaurantsReviews(
                      review: review,
                      restaurantData: widget.restaurantData,
                    ),
                  ],
                )),
                // index==1?const RestaurantsReviews():
              ],
            ),
          ),
        ),
        body: ImageCacheR(widget.restaurantData.coverPic),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<RestaurantViewModel>()
          .getReview(widget.restaurantData.restId)
          .then((value) {
            if(mounted){
              setState(() {
                review = value;
              });
            }
      });
    });
  }
}
