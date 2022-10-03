import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

class PlatterwiseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  const PlatterwiseAppBar({
    Key? key,
    this.bottom,
    this.automaticallyImplyLeading = true
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppBar(
        bottom: bottom,
        elevation: 0,
        automaticallyImplyLeading: automaticallyImplyLeading,
        centerTitle: false,
        backgroundColor: Colors.white,
        actions: [
          SvgPicture.asset("assets/icon/notification-bing.svg")
        ],
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 28, maxWidth: 300),
          child: SvgPicture.asset(
            "assets/icon/platterwise_logo.svg",
            height: 15.h,
            width: 161.w,
          )
        ),
      ),
    );
  }
}
