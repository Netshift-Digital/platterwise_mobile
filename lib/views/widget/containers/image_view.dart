import 'package:flutter/material.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class FullImage extends StatelessWidget {
  final String imageUrl;
  const FullImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar(context,appbarColor: Colors.white),
      body: InteractiveViewer(
          child:ImageCacheR(imageUrl,chachedImage: true,)
      ),
    );
  }
}
