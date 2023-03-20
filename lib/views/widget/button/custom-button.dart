import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/enum/app_state.dart';

class PlatButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final double width, height, radius, textSize, padding, iconSize, spacing;
  final Color? iconColor, color, textColor;
  final Widget? icon;
  final AppState appState;
  const PlatButton({
    this.icon,
    this.radius = 10,
    this.appState = AppState.idle,
    this.width = double.maxFinite,
    this.height = 54,
    this.color = AppColor.p300,
    this.textColor,
    this.iconColor,
    required this.title,
    required this.onTap,
    this.textSize = 18,
    this.iconSize = 17,
    this.padding = 15,
    this.spacing = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: appState == AppState.busy ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: onTap==null?Colors.grey:color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: appState == AppState.busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppTextTheme.h3.copyWith(
                            fontSize: textSize,
                            fontWeight: FontWeight.w500,
                            color: textColor ?? AppColor.g0),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
