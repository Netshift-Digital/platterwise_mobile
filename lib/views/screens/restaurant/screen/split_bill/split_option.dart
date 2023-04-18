import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/enum/split_type.dart';
import 'package:platterwave/utils/extension.dart';

class SplitOption extends StatelessWidget {
  final SplitType splitType;
  final Function(SplitType e) onSelect;
  const SplitOption({Key? key, required this.splitType, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(left: 18,right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height:4,
                  width: 69,
                  decoration: BoxDecoration(
                    color:const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.clear,
                      size: 30,
                    ))
              ],
            ),
            const SizedBox(height: 10,),
            Text('Choose Split options',style: AppTextTheme.h3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500
            ),),
            const SizedBox(height: 8,),
            Text('Tap to select one split option',style: AppTextTheme.h3.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.g800
            ),),
            const SizedBox(height: 40,),
            selectWid(
              SplitType.custom,
            ),
            const SizedBox(height: 20,),
            selectWid(
              SplitType.equally,
            ),
            const SizedBox(height: 20,),
            selectWid(
              SplitType.percentage,
            )
          ],
        ),
      ),
    );
  }

  Widget selectWid(SplitType custom) {
    return GestureDetector(
      onTap: (){
        onSelect(custom);
      },
      child: Container(
        height: 55,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: const Color(0xffF2F2F2),
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.only(left: 18,right: 18),
          child: Row(
            children: [
              SizedBox(
                height: 19,
                width: 19,
                child: custom==splitType?SvgPicture.asset('assets/icon/element-equal.svg'):const SizedBox(),
              ),
              const SizedBox(width: 18,),
              Text(
                custom.name.capitalizeFirstChar(),
                style: AppTextTheme.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.g700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
