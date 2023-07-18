import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/views/screens/restaurant/screen/restaurant_component/photo_view_page.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:readmore/readmore.dart';

class ResDetails extends StatelessWidget {
  final RestaurantData restaurantData;
  const ResDetails({Key? key, required this.restaurantData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          ReadMoreText(
            restaurantData.descriptions,
            style: AppTextTheme.h3.copyWith(fontSize: 16),
            moreStyle:
                AppTextTheme.h3.copyWith(fontSize: 14, color: AppColor.p200),
            lessStyle:
                AppTextTheme.h3.copyWith(fontSize: 14, color: AppColor.p200),
          ),
          const SizedBox(
            height: 33,
          ),
          Row(
            children: [
              Text(
                'Photos',
                style: AppTextTheme.h3
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  nav(
                    context,
                    PhotoViewPage(
                      photos:
                          restaurantData.menuPix.map((e) => e.menuPic).toList(),
                      index: 0,
                    ),
                  );
                },
                child: Text(
                  'See More',
                  style: AppTextTheme.h3.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColor.p200,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: restaurantData.menuPix.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index > 2) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    height: 80,
                    width: 130,
                    child: GestureDetector(
                      onTap: () {
                        nav(
                            context,
                            PhotoViewPage(
                                photos: restaurantData.menuPix
                                    .map((e) => e.menuPic)
                                    .toList(),
                                index: index));
                      },
                      child: ImageCacheR(
                        restaurantData.menuPix[index].menuPic,
                        chachedImage: true,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 93,
          ),
        ],
      ),
    );
  }
}
