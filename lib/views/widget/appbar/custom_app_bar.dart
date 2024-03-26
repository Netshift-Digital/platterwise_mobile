import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/text-theme.dart';

import '../../../res/color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final double? padding;
  final String trailing;
  final void Function()? onTap;
  final bool showMenuB;
  PreferredSizeWidget? bottom;

  CustomAppBar(
      {Key? key,
      this.bottom,
      this.automaticallyImplyLeading = true,
      required this.trailing,
      this.padding,
      this.onTap,
      this.showMenuB = true})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      backgroundColor: AppColor.g0,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: false,
      actions: [
        showMenuB
            ? Padding(
                padding: EdgeInsets.only(right: padding ?? 30),
                child: InkWell(onTap: onTap, child: SvgPicture.asset(trailing)),
              )
            : const SizedBox()
      ],
    );
  }
}
