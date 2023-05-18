import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/model/restaurant/restaurant_review.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/screens/restaurant/screen/rate_experience_screen.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RestaurantsReviews extends StatefulWidget {
  List<AllRestReview> review;
  final RestaurantData restaurantData;
   RestaurantsReviews({Key? key, required this.review, required this.restaurantData}) : super(key: key);

  @override
  State<RestaurantsReviews> createState() => _RestaurantsReviewsState();
}

class _RestaurantsReviewsState extends State<RestaurantsReviews> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var user = context.read<UserViewModel>().user;
    var resViewModel = context.read<RestaurantViewModel>();
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: widget.review.length,
              primary: false,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = widget.review[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.g20,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ImageCacheCircle(
                                data.profileUrl,
                                height: 32,
                                width: 32,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                data.fullName,
                                style: AppTextTheme.h3.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 14.sp),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: (num.tryParse(data.rating)??0).toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 18.0,
                                direction: Axis.horizontal,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                               Text(
                               RandomFunction.timeAgo(data.timestamp),
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(data.review),
                        ],
                      ),
                    ),
                  ),
                );
              },
          ),
        ),
        GestureDetector(
          onTap: ()async{
           var data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>RateExperienceScreen(restaurantData: widget.restaurantData)));
           if(data!=null){
             setState(() {
               widget.review = data;
             });
           }
          },
          child: PhysicalModel(
            color: Colors.black,
            elevation: 3,
            child: Container(
              height: 125,
              width: size.width,
              color: Colors.white,
              child: SafeArea(
                child: Row(
                  children: [
                    ImageCacheCircle(
                      user==null?"":user.userProfile.profileUrl,
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                        child: TextField(
                      controller: commentController,
                      enabled: false,
                      onSubmitted: (e){
                        if(e.isNotEmpty){
                         resViewModel.addReview(
                             resId: widget.restaurantData.restId,
                             review: e.trim(),
                             rate: '5'
                         ).then((value){
                          widget.review = value;
                          if(mounted){
                            setState(() {});
                          }
                         });
                         commentController.clear();
                        }
                      },
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Add a comment ",
                          filled: true,
                          fillColor: AppColor.g30
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
