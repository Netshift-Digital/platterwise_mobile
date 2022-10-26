import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

class SearchSuggestionsTile extends StatelessWidget {
  const SearchSuggestionsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            decoration: BoxDecoration(
              color: AppColor.p75,
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          Text("Esther Howard"),
          Spacer(),
          SvgPicture.asset("assets/icon/cancel.svg")
        ],
      ),
    );
  }
}
