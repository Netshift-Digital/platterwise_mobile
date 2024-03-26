import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/screens/auth/forgot_password.dart';
import 'package:platterwave/views/screens/auth/register.dart';
import 'package:platterwave/views/screens/bottom_nav/bottom_nav.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/text_field.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AnnotatedRegion(
        value: kOverlay,
        child: Scaffold(
          // appBar: appBar(context),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: sixteen, right: sixteen, bottom: sixteen),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: twenty,
                      ),
                      Text(
                        "Sign in",
                        style: AppTextTheme.h4.copyWith(
                            fontSize: twentyFour,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: fiftyFour,
                      ),
                      Text("Email", style: AppTextTheme.hint),
                      const SizedBox(
                        height: hintSpacing,
                      ),
                      Field(
                        controller: _email,
                        hint: "Input Email",
                        textInputType: TextInputType.emailAddress,
                        validate: FieldValidator.email(),
                      ),
                      const SizedBox(
                        height: twenty,
                      ),
                      Text("Password", style: AppTextTheme.hint),
                      const SizedBox(
                        height: hintSpacing,
                      ),
                      Field(
                        controller: _password,
                        hint: "Input Password",
                        isPassword: true,
                        validate: FieldValidator.minLength(3),
                      ),
                      const SizedBox(
                        height: four,
                      ),
                      GestureDetector(
                        onTap: () {
                          nav(context, const ForgotPassword());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forgot password",
                              style: AppTextTheme.h4.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      PlatButton(
                          appState: context.watch<UserViewModel>().appState,
                          // color: _formKey.currentState!.validate()?null :AppColor.g500,
                          title: "Sign in",
                          onTap: () {
                            login(context);
                          }),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: SvgPicture.asset(
                                  "assets/icon/login with.svg")),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      // Row(
                      //   //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //   const Spacer(),
                      //    // Platform.isIOS?GestureDetector(
                      //    //    onTap: (){},
                      //    //      child: SvgPicture.asset("assets/icon/apple.svg"))
                      //    //  :const SizedBox(),
                      //    //  Platform.isIOS?const Spacer():const SizedBox(),
                      //     Platform.isAndroid?GestureDetector(
                      //       onTap: (){
                      //          facebook(context);
                      //       },
                      //         child: SvgPicture.asset("assets/icon/facebook.svg")):const SizedBox(),
                      //     Platform.isAndroid?const SizedBox(width: 20,):const SizedBox(),
                      //     InkWell(
                      //       onTap: (){
                      //         google(context);
                      //       },
                      //         child: Image.asset("assets/icon/google.png")),
                      //     const Spacer(),
                      //   ],
                      // ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(),
                          Text(
                            "we wont share your information without your permission",
                            style: AppTextTheme.hint.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColor.g500),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          GestureDetector(
                            onTap: () {
                              nav(context, const Register());
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'No account yet? ',
                                    style: AppTextTheme.h6.copyWith(
                                        fontSize: 14, color: AppColor.g500),
                                  ),
                                  TextSpan(
                                    text: 'Create an account',
                                    style: AppTextTheme.h6.copyWith(
                                        color: AppColor.p200, fontSize: 14),
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

  void login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context
          .read<UserViewModel>()
          .login(_email.text, _password.text)
          .then((value) {
        if (value != null && value == true) {
          nav(context, const BottomNav(), remove: true);
        }
      });
    }
  }

  Future<void> google(BuildContext context) async {
    context.read<UserViewModel>().google().then((value) {
      if (value != null) {
        if (value.newUser) {
          nav(
              context,
              Register(
                authMethod: value,
              ));
        } else {
          nav(context, const BottomNav(), remove: true);
        }
      }
    });
  }

  Future<void> facebook(BuildContext context) async {
    context.read<UserViewModel>().signInWithFacebook().then((value) {
      if (value != null) {
        if (value.newUser) {
          nav(
              context,
              Register(
                authMethod: value,
              ));
        } else {
          nav(context, const BottomNav(), remove: true);
        }
      }
    });
  }
}
