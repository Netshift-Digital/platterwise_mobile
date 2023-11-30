import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/large_restaurant_container.dart';

class MoreRestaurant extends StatelessWidget {
  final List<RestaurantData> closeByRestaurant;
  const MoreRestaurant({Key? key, required this.closeByRestaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: closeByRestaurant.length,
          itemBuilder: (BuildContext context, int index) {
            var data = closeByRestaurant[index];
            return LargeRestaurantContainer(
              restaurantData: data,
              id: data.restId,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 20.h,
            );
          },
        ),
      ),
    );
  }
}
