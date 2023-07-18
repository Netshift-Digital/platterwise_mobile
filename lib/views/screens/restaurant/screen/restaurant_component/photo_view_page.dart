import 'package:cached_network_image/cached_network_image.dart';
import 'package:disposable_cached_images/disposable_cached_images.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class PhotoViewPage extends StatelessWidget {
  final List<String>? photos;
  final int index;

  const PhotoViewPage({
    Key? key,
    required this.photos,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        itemCount: photos!.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: DisposableCachedImage.network(
            imageUrl: photos![index],
            onLoading: (context, url, u) {
              return const Center(child: CircularProgressIndicator());
            },
            onError: (context, url, error, w) => Container(
              color: Colors.black,
              child: const EmptyContentContainer(
                errorText: "Error loading image",
              ),
            ),
          ),
          minScale: PhotoViewComputedScale.covered,
          heroAttributes: PhotoViewHeroAttributes(tag: photos![index]),
        ),
        pageController: PageController(initialPage: index),
        enableRotation: true,
      ),
    );
  }
}
