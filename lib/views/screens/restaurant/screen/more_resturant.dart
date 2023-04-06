import 'package:flutter/material.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/large_restaurant_container.dart';
import 'package:provider/provider.dart';

class MoreRestaurant extends StatelessWidget {
  const MoreRestaurant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    var resModel = context.watch<RestaurantViewModel>();
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: resModel.allRestDetail.length,
          itemBuilder: (BuildContext context, int index) {
            var data = resModel.allRestDetail[index];
            return LargeRestaurantContainer(
              restaurantData: data,
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
