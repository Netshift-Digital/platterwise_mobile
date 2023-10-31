import 'package:flutter/material.dart';
import 'package:platterwave/model/restaurant/banner_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class BannerDetails extends StatelessWidget {
  final BannerDetail data;
  const BannerDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
        child: PlatButton(
            title: "Done",
            onTap: () {
              Navigator.pop(context);
            }),
      ),
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              data.name,
              style: const TextStyle(
                color: Color(0xFF5C5C5C),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            data.banner.isNotEmpty
                ? Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8)),
                    child: ImageCacheR(data.banner),
                  )
                : Image.asset(
                    'assets/images/discount-banner 1.png',
                    fit: BoxFit.cover,
                    height: 120,
                  ),
            const SizedBox(
              height: 40,
            ),
            Text(
              data.descriptions ?? "",
              style: const TextStyle(
                color: Color(0xFF646464),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
