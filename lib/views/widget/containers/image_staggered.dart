import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/views/screens/restaurant/screen/restaurant_component/photo_view_page.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class ImageStag extends StatelessWidget {
  final List<String> images;
  const ImageStag({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: GestureDetector(
            onTap: () {
              nav(context, PhotoViewPage(photos: images, index: 0));
            },
            child: ImageCacheR(
              images[0],
              height: 200,
              width: 200,
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: GestureDetector(
            onTap: () {
              nav(context, PhotoViewPage(photos: images, index: 1));
            },
            child: ImageCacheR(
              images[1],
              height: 200,
              width: 200,
            ),
          ),
        ),
        images.length > 2
            ? StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 2,
                child: GestureDetector(
                  onTap: () {
                    nav(context, PhotoViewPage(photos: images, index: 2));
                  },
                  child: Stack(
                    children: [
                      ImageCacheR(
                        images[2],
                        height: 200,
                        width: double.maxFinite,
                        blend: 0.2,
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '+${images.length - 2}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
