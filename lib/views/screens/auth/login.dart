import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/views/screens/auth/otp.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/country_field.dart';
import 'package:platterwave/views/widget/text_feild/text_feild.dart';
import 'package:the_validator/the_validator.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController _email =  TextEditingController();
  final TextEditingController _password =  TextEditingController();
final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: twenty,),
                      Text("Sign in",style: AppTextTheme.h4.copyWith(
                          fontSize: twentyFour,
                          fontWeight: FontWeight.w700
                      ),),
                      const SizedBox(height: fiftyFour,),
                      Text("Email",style: AppTextTheme.hint),
                      const SizedBox(height: hintSpacing,),
                      Field(
                        controller: _email,
                        hint: "gsswuw@gmail.com",
                        validate: FieldValidator.email(),
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
                     const SizedBox(height:four,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Text("Forgot password",style: AppTextTheme.h4.copyWith(
                           fontSize: 14,
                           fontWeight: FontWeight.w500
                         ),)
                       ],
                     ),
                     SizedBox(height: size.height*0.07,),
                      PlatButton(
                       // color: _formKey.currentState!.validate()?null :AppColor.g500,
                          title: "Create your account",
                          onTap: (){
                            nav(context,Otp());
                          }
                      ),
                      SizedBox(height: size.height*0.05,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         SvgPicture.asset("assest/icon/login with.svg"),
                       ],
                     ),
                      SizedBox(height: size.height*0.02,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(width: 1,),
                          SvgPicture.asset("assest/icon/apple.svg"),
                          SvgPicture.asset("assest/icon/facebook.svg"),
                          Image.asset("assest/icon/google.png"),
                          const SizedBox(width: 1,),
                        ],
                      ),
                      SizedBox(height: size.height*0.02,),
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
                          SizedBox(height: size.height*0.04,),
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'No account yet? ',
                                    style: AppTextTheme.h6.copyWith(
                                        fontSize: 14,
                                        color: AppColor.g500
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Create an account',
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
      ),
    );
  }
}
