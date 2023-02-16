import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/views/screens/restaurant/screen/reviews.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:readmore/readmore.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RestaurantDetails extends StatefulWidget {
  const RestaurantDetails({Key? key}) : super(key: key);

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  String bunch =
      'De Place Restaurant is a dining establishment that serves a variety of cuisine to its customers.The restaurant may offer an extensive menu,with options for breakfast, lunch, and dinner... ';
  int index = 0;
  PageController pageController = PageController();
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
                      'De Place Restaurant',
                      style: AppTextTheme.h3
                          .copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    const Spacer(),
                    SvgPicture.asset('assets/icon/route-square.svg'),
                    const SizedBox(
                      width: 12,
                    ),
                    SvgPicture.asset('assets/icon/route2.svg'),
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
                    const Text(
                      '(20 reviews)',
                      style: TextStyle(color: AppColor.g100),
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
                    const Expanded(
                        child: Text(
                            '2118 Thornridge Cir. Syracuse, Connecticut 35624'))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
                        pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
                      onPageChanged: (e){
                        setState(() {
                          index=e;
                        });
                      },
                      physics:const BouncingScrollPhysics(),
                   children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReadMoreText(
                          bunch,
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
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  height: 80,
                                  width: 111,
                                  child: ImageCacheR(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png'),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 93,
                        ),
                        PlatButton(title: 'Make Reservation', onTap: () {})
                      ],
                    ),
                    const RestaurantsReviews(),
                  ],
                )),
                // index==1?const RestaurantsReviews():
              ],
            ),
          ),
        ),
        body: Image.asset(
          'assets/images/1.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      if(mounted){
        setState(() {
         var p =pageController.page??0;
         index=p.toInt();
        });
      }
    });
  }
}
