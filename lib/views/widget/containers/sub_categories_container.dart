import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

class SubCategoriesContainer extends StatelessWidget {
  final String? image;
  final String title;

  const SubCategoriesContainer({
    Key? key,
    this.image,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 85.h,
          width: 145.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColor.p300
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(title, style: AppTextTheme.h4,),
      ],
    );
  }
}
