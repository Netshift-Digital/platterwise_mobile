import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

class EmptyContentContainer extends StatelessWidget {
  final String? errorText;
  const EmptyContentContainer({Key? key, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 58.h,),
          SvgPicture.asset("assets/icon/no-content-saved.svg"),
          SizedBox(height: 20.h,),
          Text("Nothing here!", style: AppTextTheme.large.copyWith(
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 12.h,),
          Text(
            errorText ?? "Nothing to see here!",
            textAlign: TextAlign.center,
            style: AppTextTheme.h4,
          ),
        ],
      ),
    );
  }
}
