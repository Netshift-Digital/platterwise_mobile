import 'package:flutter/material.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/banner_screen.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  PageController pageController = PageController(viewportFraction: 1);
  @override
  Widget build(BuildContext context) {
    var resModel = context.watch<RestaurantViewModel>();
    //resModel.allBannersList
    return Padding(
      padding: const EdgeInsets.only(top: 42, bottom: 24),
      child: Column(
        children: [
          SizedBox(
            height: 130,
            child: PageView(
              physics: const BouncingScrollPhysics(),
              controller: pageController,
              children: resModel.allBannersList.map((data) {
                return GestureDetector(
                  onTap: () {
                    nav(context, BannerDetails(data: data));
                  },
                  child: data.banner.isNotEmpty
                      ? Container(
                          height: 120,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8)),
                          child: ImageCacheR(data.banner),
                        )
                      : Image.asset(
                          'assets/images/discount-banner 1.png',
                          fit: BoxFit.cover,
                          height: 120,
                        ),
                );
                // return GestureDetector(
                //   onTap: () {
                //     nav(context, BannerDetails(data: data));
                //   },
                //   child: data.banner.isNotEmpty
                //       ? Container(
                //           decoration: BoxDecoration(
                //               color: Colors.grey.shade200,
                //               borderRadius: BorderRadius.circular(8)),
                //           child: ImageCacheR(data.banner),
                //         )
                //       : Image.asset(
                //           'assets/images/discount-banner 1.png',
                //           fit: BoxFit.cover,
                //         ),
                // );
              }).toList(),
            ),
          ),
          // SizedBox(
          //   height: 130,
          //   child: PageView.builder(
          //     physics: const BouncingScrollPhysics(),
          //     controller: pageController,
          //      padEnds: true,
          //     itemCount: resModel.allBannersList.length,
          //       itemBuilder:(context, index){
          //       var data = resModel.allBannersList[index];
          //         return data.banner.isNotEmpty?
          //             Container(
          //               decoration: BoxDecoration(
          //                 color: Colors.grey.shade200,
          //                 borderRadius: BorderRadius.circular(8)
          //               ),
          //                 child: ImageCacheR(data.banner),
          //             )
          //             :Image.asset('assets/images/discount-banner 1.png',fit: BoxFit.cover,);
          //       }
          //   ),
          // ),
          const SizedBox(
            height: 16,
          ),
          SmoothPageIndicator(
              controller: pageController, // PageController
              count: resModel.allBannersList.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColor.p200,
                dotWidth: 6,
                dotHeight: 6,
              ), // your preferred effect
              onDotClicked: (index) {})
        ],
      ),
    );
  }
}
