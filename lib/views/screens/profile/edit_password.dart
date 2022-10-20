import 'package:flutter/material.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';

import '../../../res/color.dart';
import '../../widget/button/custom-button.dart';
import '../../widget/text_feild/app_textfield.dart';

class EditPasswordScreen extends StatelessWidget {
  const EditPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 100.h,),
            Align(
                alignment: Alignment.topLeft,
                child: Text("New Password")
            ),
            SizedBox(height: 8.h,),
            AppTextField(),
            SizedBox(height: 18.h,),
            Align(
                alignment: Alignment.topLeft,
                child: Text("Confirm New Password")
            ),
            SizedBox(height: 8.h,),
            AppTextField(),
            SizedBox(height: 220.h,),
            PlatButton(
                title: "Change Password",
                onTap: (){}
            )
          ],
        ),
      ),
    );
  }
}
