// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/restaurant_component/res_bottom.dart';
import 'package:platterwave/views/screens/restaurant/screen/restaurant_component/res_details.dart';
import 'package:platterwave/views/screens/restaurant/screen/restaurant_component/res_header.dart';
import 'package:platterwave/views/screens/restaurant/screen/restaurant_component/res_tab.dart';
import 'package:platterwave/views/screens/restaurant/screen/reviews.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/custom/page_view.dart';
import 'package:provider/provider.dart';

class Res extends StatefulWidget {
  RestaurantData? restaurantData;
  final int id;
  Res({super.key, this.restaurantData, required this.id})
      : assert(!(restaurantData == null && id == null),
            "pass either restId or RestaurantData");

  @override
  State<Res> createState() => _ResState();
}

class _ResState extends State<Res> {
  int index = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    if (widget.restaurantData == null) {
      return Scaffold(
        appBar: appBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      bottomNavigationBar: RestaurantBottom(
          restaurantData: widget.restaurantData!,
          index: index,
          onReview: (e) {
            setState(() {
              widget.restaurantData!.review = e;
            });
          }),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 294,
            pinned: true,
            systemOverlayStyle: kOverlay,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            leading: Column(
              children: [
                GestureDetector(
                  child: SizedBox(
                    width: 39,
                    height: 39,
                    child: SvgPicture.asset('assets/icon/back.svg'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  context
                      .read<RestaurantViewModel>()
                      .saveRestaurant(widget.restaurantData!);
                },
                child: SizedBox(
                  width: 39,
                  height: 39,
                  child: context
                          .watch<RestaurantViewModel>()
                          .isFavourite(widget.restaurantData!.restId.toString())
                      ? SvgPicture.asset('assets/icon/heart.svg')
                      : SvgPicture.asset('assets/icon/favour_rite.svg'),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
            stretch: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
              ],
              collapseMode: CollapseMode.pin,
              background: Column(
                children: [
                  Expanded(
                    child: ImageCacheR(
                      widget.restaurantData!.coverPic,
                      topRadius: 0,
                      topBottom: 0,
                    ),
                  ),
                  RestaurantHeader(
                    restaurantData: widget.restaurantData!,
                    review: widget.restaurantData!.review,
                  ),
                ],
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            primary: false,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            toolbarHeight: 0,
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size(double.maxFinite, 60),
              child: RestaurantTab(
                index: index,
                onTap: (e) {
                  pageController.animateToPage(
                    e,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ExpandablePageView(
                controller: pageController,
                onPageChanged: (e) {
                  setState(() {
                    index = e;
                  });
                },
                children: [
                  ResDetails(restaurantData: widget.restaurantData!),
                  RestaurantsReviews(
                    review: widget.restaurantData!.review,
                    restaurantData: widget.restaurantData!,
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /* context
          .read<RestaurantViewModel>()
          .getReview((widget.id ?? widget.restaurantData!.restId).toString())
          .then((value) {
        if (mounted) {
          setState(() {
            review = value;
          });
        }
      });
*/
      context
          .read<RestaurantViewModel>()
          .getRestaurantById(widget.id)
          .then((value) {
        if (mounted) {
          setState(() {
            widget.restaurantData = value!;
          });
        }
      });
    });
  }
}
