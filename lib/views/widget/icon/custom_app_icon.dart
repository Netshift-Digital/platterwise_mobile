import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

class CustomAppIcon extends StatelessWidget {
  final String icon;
  final String count;
  final Widget? like;
  final void Function()? onTap;
  final void Function()? onTextTap;

  const CustomAppIcon({
    Key? key,
    required this.icon,
    required this.count,
    this.onTap,
    this.like,
    this.onTextTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Row(
      children: [
        like??GestureDetector(
          onTap: onTap,
            child: SvgPicture.asset(icon)
        ),
        SizedBox(width: 8.w,),
        GestureDetector(
          onTap: onTextTap,
            child: Text(count),
        )
      ],
    );
  }
}
