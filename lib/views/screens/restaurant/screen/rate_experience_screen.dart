import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../widget/text_feild/app_textfield.dart';

class RateExperienceScreen extends StatefulWidget {
  final RestaurantData restaurantData;
  const RateExperienceScreen({Key? key, required this.restaurantData})
      : super(key: key);

  @override
  State<RateExperienceScreen> createState() => _RateExperienceScreenState();
}

class _RateExperienceScreenState extends State<RateExperienceScreen> {
  List<bool> values = [false, false, false, false, false, false];
  List improve = [];
  num rate = 4;
  final TextEditingController controller = TextEditingController();

  void toggleChip(bool toogle, int index) {
    values[index] = !toogle;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBar(context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rate Your Experience",
                    style: AppTextTheme.h1,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  const Text("Are you satisfied with your experience"),
                  SizedBox(
                    height: 20.h,
                  ),
                  RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: AppColor.kAmber),
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (rating) {
                      rate = rating;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  const Text("Tell us what we can improve?"),
                  SizedBox(
                    height: 20.h,
                  ),
                  Wrap(
                    spacing: 12,
                    children: [
                      GestureDetector(
                        onTap: () => toggleChip(values[0], 0),
                        child: Chip(
                          backgroundColor:
                              values[0] ? AppColor.p300 : AppColor.g300,
                          label: const Text("Hospitality"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleChip(values[1], 1),
                        child: Chip(
                          backgroundColor: values[1] ? AppColor.p300 : AppColor.g80,
                          label: const Text("Customer Service"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleChip(values[2], 2),
                        child: Chip(
                          label: const Text("Food Quality"),
                          backgroundColor: values[2] ? AppColor.p300 : AppColor.g80,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleChip(values[3], 3),
                        child: Chip(
                          backgroundColor: values[3] ? AppColor.p300 : AppColor.g80,
                          label: const Text("Menu Varities"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleChip(values[4], 4),
                        child: Chip(
                          backgroundColor: values[4] ? AppColor.p300 : AppColor.g80,
                          label: const Text("Environment"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => toggleChip(values[5], 5),
                        child: Chip(
                          backgroundColor: values[5] ? AppColor.p300 : AppColor.g80,
                          label: const Text("Dishes"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  AppTextField(
                    controller: controller,
                    onChanged: (e){
                      setState(() {});
                    },
                    hintText: "Add a brief introduction about you.",
                    maxLines: 8,
                  ),
                  const SizedBox(height: 30,),
                  PlatButton(
                    title: "Submit",
                    onTap:controller.text.isNotEmpty? () {
                       if(controller.text.isNotEmpty){
                         var resViewModel = context.read<RestaurantViewModel>();
                         resViewModel.addReview(
                             resId: widget.restaurantData.restId,
                             review: controller.text,
                             rate: rate.toString()
                         ).then((value){
                           Navigator.pop(context,value);
                         });
                       }
                    }:null,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
