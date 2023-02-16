
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';


var placeText = "I recently dined at De Place Restaurant and was blown away by the quality of the food and the service. The menu had a great selection of dishes, and I was impressed by the use of fresh ingredients in every dish.";
class RestaurantsReviews extends StatelessWidget {
  const RestaurantsReviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        primary: false,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context,index){
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
                        const ImageCacheCircle(kPlaceHolder,height:32,width: 32,),
                       const SizedBox(width: 8,),
                        Text('Leslie Alexander',style: AppTextTheme.h3.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp
                        ),),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: 2.75,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 18.0,
                          direction: Axis.horizontal,
                        ),
                        const Text('. 5 days ago',
                        style: TextStyle(
                          fontSize: 10,
                        ),),

                      ],
                    ),
                    const SizedBox(height: 8,),
                    Text(placeText),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
