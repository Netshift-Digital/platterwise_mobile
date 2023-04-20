import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/pin_field.dart';

class Otp extends StatelessWidget {
  Otp({Key? key}) : super(key: key);
final TextEditingController _otp = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        physics:const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(),
             Text("Verify Phone Number",style: AppTextTheme.large.copyWith(
               fontWeight: FontWeight.w700,
               fontSize: 24
             ),),
              const SizedBox(height: eight,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Please enter the 4 digit code sent to\n',
                      style: AppTextTheme.h6.copyWith(
                          fontSize: 12,
                          color: AppColor.g400
                      ),
                    ),
                    TextSpan(
                      text: '(234) 55-0114-2346 ',
                      style: AppTextTheme.h6.copyWith(
                          color:AppColor.g700,
                          fontSize: 12,
                        fontWeight: FontWeight.w500
                      ),
                    ),
              TextSpan(
                      text: 'through SMS',
                      style: AppTextTheme.h6.copyWith(
                          fontSize: 12,
                          color: AppColor.g400
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: sixteen,),
             // PinField(
             //     controller: _otp
             // ),
              const SizedBox(height: thirtyTwo,),
              GestureDetector(
                onTap: (){

                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Didn’t recieve a code? ',
                        style: AppTextTheme.h6.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.g500
                        ),
                      ),
                      TextSpan(
                        text: 'Resend SMS',
                        style: AppTextTheme.h6.copyWith(
                            color:AppColor.p200,
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: sixtyFour,),
              PlatButton(
                  title: "Verify",
                  onTap: (){

                  }
              ),
              const SizedBox(height: eight,),
              Text('By continuing you’re indicating that you accept our Terms of Use and our Privacy Policy',
              style: AppTextTheme.h5,
              textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }

}
