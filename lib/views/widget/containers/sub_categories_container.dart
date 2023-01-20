import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

class SubCategoriesContainer extends StatelessWidget {
  final String? image;
  final String title;
  final Function() onTap;

  const SubCategoriesContainer({
    Key? key,
    this.image,
    required this.title, required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap:onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150.w,
              height: 80.h,
              child: Image.asset(image!,fit: BoxFit.fill,)),
          SizedBox(
            height: 2.h,
          ),
          Text(title, style: AppTextTheme.h4,),
        ],
      ),
    );
  }
}
