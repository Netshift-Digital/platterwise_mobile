import 'package:flutter/material.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';

import '../../../../res/color.dart';
import '../../../../res/text-theme.dart';

class StartedFollowingTile extends StatelessWidget {
  final void Function()? onTap;
  final String name;
  final bool isNew;
  final String? time;

  const StartedFollowingTile({
    Key? key,
    this.onTap,
    required this.name,
    required this.isNew,
    required this.time
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        height: 110.h,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: 32.h,
              width: 32.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.p300
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 4,
                    child: RichText(
                        text: TextSpan(
                            text: name,
                            style: AppTextTheme.h4.copyWith(
                                fontWeight: FontWeight.bold
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: " posted an update!",
                                style: AppTextTheme.h4.copyWith(
                                    fontWeight: FontWeight.w400
                                ),
                              )
                            ]
                        )
                    ),
                  ),
                  SizedBox(height: 2,),
                  Flexible(child: Text(time ?? "2 hours ago"))
                ],
              ),
            ),
            Spacer(),
            Visibility(
              visible: isNew,
              child: Container(
                height: 8.h,
                width: 8.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.p300
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
