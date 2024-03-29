import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/auth/otp.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/country_field.dart';
import 'package:platterwave/views/widget/text_feild/text_feild.dart';
import 'package:the_validator/the_validator.dart';

class Register extends StatelessWidget {
   Register({Key? key}) : super(key: key);
    final TextEditingController _fullName =  TextEditingController();
   final TextEditingController _email =  TextEditingController();
   final TextEditingController _username =  TextEditingController();
   final TextEditingController _password =  TextEditingController();
   final TextEditingController _phoneNumber =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: AnnotatedRegion(
        value: kOverlay,
        child: Scaffold(
         // appBar: appBar(context),
          body: SingleChildScrollView(
            physics:const BouncingScrollPhysics(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: sixteen,right: sixteen,bottom: sixteen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const SizedBox(height: twenty,),
                     Text("Create your account",style: AppTextTheme.h4.copyWith(
                       fontSize: twentyFour,
                       fontWeight: FontWeight.w700
                     ),),
                    const SizedBox(height: fiftyFour,),
                    Text("Full name",style: AppTextTheme.hint),
                    const SizedBox(height: hintSpacing,),
                    Field(
                        controller: _fullName,
                        hint: "John Doe",
                        validate: FieldValidator.minLength(3),
                    ),
                    const SizedBox(height: twenty,),
                    Text("Email",style: AppTextTheme.hint),
                    const SizedBox(height: hintSpacing,),
                    Field(
                      controller: _email,
                      hint: "gsswuw@gmail.com",
                      validate: FieldValidator.email(),
                    ),
                    const SizedBox(height: twenty,),
                    Text("Username",style: AppTextTheme.hint),
                    const SizedBox(height: hintSpacing,),
                    Field(
                      controller: _username,
                      hint: "Johndone12",
                      validate: FieldValidator.minLength(3),
                    ),
                    const SizedBox(height: twenty,),
                    Text("Password",style: AppTextTheme.hint),
                    const SizedBox(height: hintSpacing,),
                    Field(
                      controller: _password,
                      hint: "••••••••••••••",
                      isPassword: true,
                      validate: FieldValidator.minLength(3),
                    ),
                    const SizedBox(height: twenty,),
                    Text("Phone number",style: AppTextTheme.hint),
                    const SizedBox(height: hintSpacing,),
                    CountryField(
                      controller: _phoneNumber,
                      hint: "55-0114-2346",
                      validate: FieldValidator.minLength(3),
                    ),
                    const SizedBox(height: forty,),
                    PlatButton(
                        title: "Create your account",
                        onTap: (){
                            nav(context,Otp());
                        }
                    ),
                    const SizedBox(height: eighteen,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(),
                        Text("we wont share your information without your permission",
                            style: AppTextTheme.hint.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                                color: AppColor.g500
                            )
                        ),
                        const SizedBox(height: hintSpacing,),
                        GestureDetector(
                          onTap: (){
                            nav(context, Login());
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: AppTextTheme.h6.copyWith(
                                      fontSize: 14,
                                    color: AppColor.g500
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign in',
                                  style: AppTextTheme.h6.copyWith(
                                      color:AppColor.p200,
                                      fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
