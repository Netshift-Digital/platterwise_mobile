import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';

import '../../../../res/color.dart';
import '../../../../utils/size_config/size_config.dart';
class MakeReservationScreen extends StatefulWidget {
  const MakeReservationScreen({Key? key}) : super(key: key);

  @override
  State<MakeReservationScreen> createState() => _MakeReservationScreenState();
}

class _MakeReservationScreenState extends State<MakeReservationScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
            SizedBox(height: 48,),
            AppTextField(
                prefixIcon: Container(
                  width: 31,
                  height: 31,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColor.g20,
                    shape: BoxShape.circle
                  ),
                  child: SvgPicture.asset(
                    "assets/icon/calendar.svg",
                    width: 12,
                    height: 12,),
                ),
                hintText: "Date",
                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
              ),
              SizedBox(height: 24.h,),
              AppTextField(
                prefixIcon: Container(
                  width: 31,
                  height: 31,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: AppColor.g20,
                      shape: BoxShape.circle
                  ),
                  child: SvgPicture.asset(
                    "assets/icon/timer.svg",
                    width: 12,
                    height: 12,),
                ),
                hintText: "Time",
                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
              ),
              SizedBox(height: 24.h,),
              AppTextField(
                prefixIcon: Container(
                  width: 31,
                  height: 31,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: AppColor.g20,
                      shape: BoxShape.circle
                  ),
                  child: SvgPicture.asset(
                    "assets/icon/chair.svg",
                    width: 12,
                    height: 12,),
                ),
                hintText: "Seats",
                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
              ),
              SizedBox(height: 24.h,),
              AppTextField(
                prefixIcon: Container(
                  width: 31,
                  height: 31,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: AppColor.g20,
                      shape: BoxShape.circle
                  ),
                  child: SvgPicture.asset(
                    "assets/icon/calendar.svg",
                    width: 12,
                    height: 12,),
                ),
                hintText: "Guests",
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){},
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1
                              ),
                              shape: BoxShape.circle
                          ),
                          child: Center(child: Icon(Icons.remove)),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text("2"),
                      SizedBox(width: 5,),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 1
                            ),
                            shape: BoxShape.circle
                        ),
                        child: Center(child: Icon(Icons.add)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h,),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Add Guest Details",
                  style: AppTextTheme.h3.copyWith(
                      color: AppColor.p200),
                ),
              ),
              Spacer(),
              PlatButton(
                  title: "Book Now",
                  onTap: (){},
              ),
              SizedBox(height: 24,)
            ],
          ),
        ),
      ),
    );
  }
}
