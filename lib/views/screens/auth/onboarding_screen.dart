import 'package:flutter/material.dart';
import 'package:platterwave/model/onboarding_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/auth/register.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final List<OnboardingData> list = [
    OnboardingData(
        imagePath: 'assets/images/1.png',
        title: 'Find your perfect dining experience',
        desc: 'Experience the finest flavors and impeccable service at our curated selection of restaurants.'
    ),

    OnboardingData(
        imagePath: 'assets/images/2.png',
        title: 'Instant table booking for your convenience',
        desc: 'Easily book your table with our simple and fast reservation process. No more waiting on the phone, reserve in seconds. '
    ),
    OnboardingData(
        imagePath: 'assets/images/3.png',
        title: 'Share your dinning experience',
        desc: 'Don’t keep the experiences to yourself, share it with family and friends. '
    ),

  ];
  int index = 0;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: PageView.builder(
                controller: controller,
                onPageChanged: (i) {
                  index = i;
                },
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var data = list[index];
                  return Column(
                    children: [
                      //Flexible(child: Container()),
                      Expanded(
                        flex: 3,
                        child: Image.asset(data.imagePath,fit: BoxFit.cover,),
                      ),
                       SizedBox(
                        height: 40.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:40.w,right: 40.w ),
                        child: Text(
                          data.title,
                          style: AppTextTheme.h1.copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                       SizedBox(
                        height: 24.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:38.w,right: 38.w ),
                        child: Text(
                          data.desc,
                          style: AppTextTheme.light,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }),
          ),
          SizedBox(height: 40.h,),
          Column(
            children: [
              SmoothPageIndicator(
                  controller: controller, // PageController
                  count: list.length,
                  effect:  const ExpandingDotsEffect(
                    activeDotColor: AppColor.p200,
                    dotHeight: 6,
                    radius: 8,
                    dotWidth: 8,
                  ), // your preferred effect
                  onDotClicked: (index) {}),
              SizedBox(height: 50.h,),
              GestureDetector(
                onTap: (){
                  goToLogin(context);
                },
                child: Text("Log in",
                style: AppTextTheme.h5.copyWith(
                  fontSize: 18
                ),),
              ),
              SizedBox(height: 24.h,),
              Padding(
                padding:  const EdgeInsets.only(left:16,right: 16 ),
                child: PlatButton(
                    title: 'Create account',
                    onTap:(){
                      nav(context, const Register(),remove: true);
                    }
                ),
              ),

              // Flexible(child: Container()),
            ],
          ),
          SizedBox(height: 50.h,)
        ],
      ),
    );
  }
  goToLogin(BuildContext context){
    nav(context, Login(),remove:  true);
  }
}
