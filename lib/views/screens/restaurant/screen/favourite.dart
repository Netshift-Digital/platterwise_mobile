import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/large_restaurant_container.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/pageview_model.dart';

class Favourite extends StatefulWidget {
  Favourite({Key? key}) : super(key: key);
  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  ScrollController scrollController = ScrollController();
  int _postIndex = 0;
  bool postEnd = false;
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
        body:
            Consumer<RestaurantViewModel>(builder: (context, resModel, child) {
          return resModel.favouriteRestaurant.isEmpty
              ? const Center(
                  child: EmptyContentContainer(
                    errorText: "You do not have any favourite restaurant",
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    getFav(restart: true);
                    return;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: resModel.favouriteRestaurant.length,
                      controller: scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        var data = resModel.favouriteRestaurant[index];
                        return LargeRestaurantContainer(
                          restaurantData: data,
                          id: data.restId,
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
        }));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getFav(restart: true);
      scrollController.addListener(() {
        var model = context.read<PageViewModel>();
        if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          model.hideBottomNavigator();
        } else {
          model.showBottomNavigator();
        }
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          getFav(restart: false);
        }
      });
    }
  }

  void getFav({bool restart = false}) async {
    var model = context.read<RestaurantViewModel>();
    if (restart) {
      _postIndex = 0;
      postEnd = false;
    }
    if (postEnd == false) {
      _postIndex = _postIndex + 1;
      postEnd = await model.getFavouriteRestaurant(
          restart: restart, postIndex: _postIndex);
    }
  }
}
