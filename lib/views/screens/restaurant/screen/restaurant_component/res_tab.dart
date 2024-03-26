import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';

class RestaurantTab extends StatelessWidget {
  final int index;
  final Function(int e) onTap;
  const RestaurantTab({
    Key? key,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              onTap(0);
            },
            child: Column(
              children: [
                Text(
                  "Details",
                  style: AppTextTheme.h3.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: index != 0 ? AppColor.g100 : null),
                ),
                const SizedBox(
                  height: 3,
                ),
                index != 0
                    ? const SizedBox()
                    : Container(
                        height: 1,
                        width: 32,
                        color: AppColor.p200,
                      )
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () {
              onTap(1);
            },
            child: Column(
              children: [
                Text(
                  "Reviews",
                  style: AppTextTheme.h3.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: index != 1 ? AppColor.g100 : null),
                ),
                const SizedBox(
                  height: 3,
                ),
                index != 1
                    ? const SizedBox()
                    : Container(
                        height: 1,
                        width: 32,
                        color: AppColor.p200,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
