import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/main.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/screens/auth/otp.dart';
import 'package:platterwave/views/screens/bottom_nav/bottom_nav.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/country_field.dart';
import 'package:platterwave/views/widget/text_feild/text_field.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

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
                      Text("Forgot Password",style: AppTextTheme.h4.copyWith(
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
                      SizedBox(height: size.height*0.07,),
                      PlatButton(
                          appState:context.watch<UserViewModel>().appState ,
                          // color: _formKey.currentState!.validate()?null :AppColor.g500,
                          title: "Send mail",
                          onTap: (){
                            FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text)
                                .then((value){
                                  RandomFunction.
                                  toast("We have sent a restore link to your mail");
                            });
                          }
                      ),
                      SizedBox(height: size.height*0.05,),


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

  void login(BuildContext context) {
    //nav(context, const BottomNav());
    context.read<UserViewModel>().login(
        _email.text,
        _password.text
    ).then((value){
      if(value!=null){
        nav(context, const MainPage(),remove: true);
      }
    });
  }
}
