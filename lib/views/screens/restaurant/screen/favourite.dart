import 'package:flutter/material.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/large_restaurant_container.dart';
import 'package:provider/provider.dart';

class Favourite extends StatelessWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resModel = context.watch<RestaurantViewModel>();
    return Scaffold(
      appBar: appBar(
        context,
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: resModel.favouriteRestaurant.isEmpty
          ? const Center(
              child: EmptyContentContainer(
                errorText: "You do not have any favourite restaurant",
              ),
            )
          : Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: resModel.favouriteRestaurant.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = resModel.favouriteRestaurant[index];
                  return LargeRestaurantContainer(
                    restaurantData: data,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
              ),
          ),
    );
  }
}
