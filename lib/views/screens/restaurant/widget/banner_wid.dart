import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
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
    return Padding(
      padding: const EdgeInsets.only(top: 42,bottom: 24),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: pageController,
              itemCount: 3,
                itemBuilder:(context, index){
                  return Image.asset('assets/images/discount-banner 1.png',fit: BoxFit.cover,);
                }
            ),
          ),
          const SizedBox(height: 16,),
          SmoothPageIndicator(
              controller: pageController,  // PageController
              count:  3,
              effect:  const ExpandingDotsEffect(
                activeDotColor: AppColor.p200,
                dotWidth: 6,
                dotHeight: 6,
              ),  // your preferred effect
              onDotClicked: (index){

              }
          )
        ],
      ),
    );
  }
}
