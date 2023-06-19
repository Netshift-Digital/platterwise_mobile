import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


const kPlaceHolder =
    'https://assets.goal.com/v3/assets/bltcc7a7ffd2fbf71f5/blt67a59125151d76ef/625e7dffceb10b47dfaba4dc/GettyImages-1348618431.jpg';

class ImageCacheR extends StatelessWidget {
  final double height, width, topRadius, topBottom, blend;
  final String image;
  final bool fit;
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
  }) : super(key: key);

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
      imageUrl: image.toString(),
      cacheKey:image.toString(),
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            image: DecorationImage(
                image: imageProvider,
                fit: fit ? BoxFit.cover : BoxFit.scaleDown,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(blend), BlendMode.darken)),
          ),
        );
      },
      // placeholder: (context, url) {
      //   // return Container(
      //   //   height: height,
      //   //   width: width,
      //   //   decoration: BoxDecoration(
      //   //       color: Colors.white,
      //   //       borderRadius: radius
      //   //   ),
      //   // );
      //   return Shimmer.fromColors(
      //     baseColor: Colors.grey[200]!,
      //     highlightColor: Colors.grey,
      //     direction: ShimmerDirection.ltr,
      //     child: Container(
      //       height: height,
      //       width: width,
      //       decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: radius
      //       ),
      //     ),
      //   );
      // },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(errorPlaceHolder ??
                    'https://www.pulsecarshalton.co.uk/wp-content/uploads/2016/08/jk-placeholder-image.jpg'),
                fit: fit ? BoxFit.cover : BoxFit.scaleDown),
            borderRadius: radius,
          ),
        );
      },
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
          decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
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
