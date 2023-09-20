import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disposable_cached_images/disposable_cached_images.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:platterwave/main.dart';

const kPlaceHolder =
    'https://assets.goal.com/v3/assets/bltcc7a7ffd2fbf71f5/blt67a59125151d76ef/625e7dffceb10b47dfaba4dc/GettyImages-1348618431.jpg';

class ImageCacheR extends StatefulWidget {
  final double height, width, topRadius, topBottom, blend;
  final String image;
  final bool fit;
  final bool chachedImage;
  final String? errorPlaceHolder;

  const ImageCacheR(
    this.image, {
    this.height = double.maxFinite,
    this.topRadius = 10,
    this.fit = true,
    this.blend = 0,
    this.errorPlaceHolder,
    this.topBottom = 10,
    this.width = double.maxFinite,
    Key? key,
    this.chachedImage = false,
  }) : super(key: key);

  @override
  State<ImageCacheR> createState() => _ImageCacheRState();
}

class _ImageCacheRState extends State<ImageCacheR> {
  String? image;
/*
  getCachedImagePath() async {
    var dir = kDir;
    final url = "${widget.image}.png";
    var path = '${dir.path}$url';
    if (File(path).existsSync()) {
      if (mounted) {
        setState(() {
          image = path;
        });
      }
    } else {
      downloadAndCacheImage(widget.image, path);
    }
  }

  Future<void> downloadAndCacheImage(
      String imageUrl, String cachedImagePath) async {
    try {
      var res = await Dio().download(imageUrl, cachedImagePath);
      if (mounted) {
        setState(() {
          image = cachedImagePath;
        });
      }
    } catch (e) {
      downloadAndCacheImage(
          'https://www.pulsecarshalton.co.uk/wp-content/uploads/2016/08/jk-placeholder-image.jpg',
          cachedImagePath);
    }
  }
*/
/*
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!widget.chachedImage) {
        //getCachedImagePath();
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    var radius = BorderRadius.only(
        topRight: Radius.circular(widget.topRadius),
        topLeft: Radius.circular(widget.topRadius),
        bottomLeft: Radius.circular(widget.topBottom),
        bottomRight: Radius.circular(widget.topBottom));

    return CachedNetworkImage(
      imageUrl: widget.image,
      imageBuilder: (context, imageProvider) => Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              borderRadius: radius,
              color: widget.blend > 0
                  ? Colors.black.withOpacity(widget.blend)
                  : null,
              image: DecorationImage(
                image: imageProvider,
                fit: widget.fit ? BoxFit.cover : BoxFit.scaleDown,
              ))),
      placeholder: (context, url) => Container(
        height: widget.height,
        width: widget.width,
        decoration:
            BoxDecoration(color: Colors.grey[300]!, borderRadius: radius),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      height: widget.height,
      width: widget.width,
      filterQuality: FilterQuality.none,
      fadeInDuration: Duration.zero,
      fit: widget.fit ? BoxFit.cover : BoxFit.scaleDown,
      repeat: ImageRepeat.repeat,
      colorBlendMode: BlendMode.darken,
      color: widget.blend > 0 ? Colors.black.withOpacity(widget.blend) : null,
      errorWidget: (context, url, error) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(widget.errorPlaceHolder ??
                  'https://www.pulsecarshalton.co.uk/wp-content/uploads/2016/08/jk-placeholder-image.jpg'),
              fit: widget.fit ? BoxFit.cover : BoxFit.scaleDown),
          borderRadius: radius,
        ),
      ), /* DisposableCachedImage.network(
        height: widget.height,
        keepAlive: true,
        width: widget.width,
        keepBytesInMemory: false,
        imageUrl: widget.image.toString(),
        filterQuality: FilterQuality.none,
        fit: widget.fit ? BoxFit.cover : BoxFit.scaleDown,
        fadeDuration: Duration.zero,
        repeat: ImageRepeat.repeat,
        colorBlendMode: BlendMode.darken,
        color: widget.blend > 0 ? Colors.black.withOpacity(widget.blend) : null,
        onLoading: (context, url, u) {
          return Container(
            height: widget.height,
            width: widget.width,
            decoration:
                BoxDecoration(color: Colors.grey[300]!, borderRadius: radius),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        },
        onError: (context, url, error, w) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.errorPlaceHolder ??
                      'https://www.pulsecarshalton.co.uk/wp-content/uploads/2016/08/jk-placeholder-image.jpg'),
                  fit: widget.fit ? BoxFit.cover : BoxFit.scaleDown),
              borderRadius: radius,
            ),
          );
        },
      ),*/
    );
  }
}

class ImageCacheCircle extends StatelessWidget {
  final double height, width, topRadius, topBottom, blend;
  final String image;
  final bool fit;

  const ImageCacheCircle(this.image,
      {this.height = double.maxFinite,
      this.topRadius = 10,
      this.fit = true,
      this.blend = 0,
      this.topBottom = 10,
      this.width = double.maxFinite,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var radius = BorderRadius.only(
        topRight: Radius.circular(topRadius),
        topLeft: Radius.circular(topRadius),
        bottomLeft: Radius.circular(topBottom),
        bottomRight: Radius.circular(topBottom));
    return CachedNetworkImage(
      height: height,
      width: width,
      placeholderFadeInDuration: Duration.zero,
      fadeInDuration: Duration.zero,
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: imageProvider,
              fit: fit ? BoxFit.cover : BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(blend), BlendMode.darken)),
        ),
      ),
      placeholder: (context, url) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: Colors.white.withAlpha(210), borderRadius: radius),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(
                    'https://assets.goal.com/v3/assets/bltcc7a7ffd2fbf71f5/blt67a59125151d76ef/625e7dffceb10b47dfaba4dc/GettyImages-1348618431.jpg'),
                fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
