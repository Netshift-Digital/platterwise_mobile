import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';

import '../../../../res/color.dart';
import '../../../widget/text_feild/app_textfield.dart';

class RateExperienceScreen extends StatefulWidget {
  const RateExperienceScreen({Key? key}) : super(key: key);

  @override
  State<RateExperienceScreen> createState() => _RateExperienceScreenState();
}

class _RateExperienceScreenState extends State<RateExperienceScreen> {

  List<bool> values = [false, false, false, false, false, false];

  void toggleChip (bool toogle, int index){
    values[index] = !toogle;
    setState(() {});
    print(toogle.toString());
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48.h,),
              Text("Rate Your Experience", style: AppTextTheme.h1,),
              SizedBox(height: 8.h,),
              Text("Are you satisfied with your experience"),
              SizedBox(height: 24.h,),
              RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: AppColor.kAmber),
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {
                    print(rating);
                  }),
              SizedBox(height: 24.h,),
              Divider(
                thickness: 2,
              ),
              SizedBox(height: 32.h,),
              Text("Tell us what we can improve?"),
              SizedBox(height: 24.h,),
              Wrap(
                spacing: 12,
                children: [
                  GestureDetector(
                    onTap: ()=>toggleChip(values[0], 0),
                    child: Chip(
                      backgroundColor: values[0]
                          ? AppColor.p300
                          : AppColor.g300,
                      label: Text("Hospitality"),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>toggleChip(values[1], 1),
                    child: Chip(
                      backgroundColor: values[1] ? AppColor.p300 : AppColor.g80,
                      label: Text("Customer Service"),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>toggleChip(values[2], 2),
                    child: Chip(
                      label: Text("Food Quality"),
                      backgroundColor: values[2] ? AppColor.p300 : AppColor.g80,
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>toggleChip(values[3], 3),
                    child: Chip(
                      backgroundColor: values[3] ? AppColor.p300 : AppColor.g80,
                      label: Text("Menu Varities"),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>toggleChip(values[4], 4),
                    child: Chip(
                      backgroundColor: values[4] ? AppColor.p300 : AppColor.g80,
                      label: Text("Environment"),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>toggleChip(values[5], 5),
                    child: Chip(
                      backgroundColor: values[5] ? AppColor.p300 : AppColor.g80,
                      label: Text("Dishes"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h,),
              const Divider(
                thickness: 2,
              ),
              SizedBox(height: 32.h,),
              const AppTextField(
                hintText: "Add a brief introduction about you.",
                maxLines: 8,
              ),
              Spacer(),
              PlatButton(title: "Submit", onTap: (){}),
              SizedBox(
                height: 12.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
