import 'package:flutter/material.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          children: [
            SizedBox(height: 100.h,),
            Align(
              alignment: Alignment.topLeft,
                child: Text("Display Name")
            ),
            SizedBox(height: 8.h,),
            AppTextField(
              hintText: "John Doe",
            ),
            SizedBox(height: 18.h,),
            Align(
                alignment: Alignment.topLeft,
                child: Text("Username")
            ),
            SizedBox(height: 8.h,),
            AppTextField(
              hintText: "Johndoe12",
            ),
            SizedBox(height: 18.h,),
            Align(
                alignment: Alignment.topLeft,
                child: Text("Gender")
            ),
            SizedBox(height: 8.h,),
            AppTextField(
              hintText: "Male",
            ),
            SizedBox(height: 18.h,),
            Align(
                alignment: Alignment.topLeft,
                child: Text("Add bio")
            ),
            SizedBox(height: 8.h,),
            AppTextField(
              hintText: "Add a brief introduction about you.",
              maxLines: 6,
            ),
            SizedBox(height: 70.h,),
            PlatButton(
                title: "Update",
                onTap: (){}
            )
          ],
        ),
      ),
    );
  }
}
