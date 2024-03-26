import 'package:flutter/material.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/text_feild/text_field.dart';
import 'package:provider/provider.dart';
import 'package:the_validator/the_validator.dart';

import '../../../view_models/user_view_model.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ResetPassword> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _token = TextEditingController();

  bool isLoading = false;

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
          appBar: appBar(context),
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
                        "Reset Password",
                        style: AppTextTheme.h4.copyWith(
                            fontSize: twentyFour, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: eighty,
                      ),
                      Text("Email", style: AppTextTheme.hint),
                      const SizedBox(
                        height: hintSpacing,
                      ),
                      Field(
                        controller: _email,
                        hint: "Enter your email address",
                        validate: FieldValidator.email(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Password", style: AppTextTheme.hint),
                      const SizedBox(
                        height: hintSpacing,
                      ),
                      Field(
                        controller: _password,
                        hint: "Enter your new password",
                        validate: FieldValidator.password(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Token", style: AppTextTheme.hint),
                      const SizedBox(
                        height: hintSpacing,
                      ),
                      Field(
                        controller: _token,
                        hint: "Enter the token sent to your mail",
                        validate: FieldValidator.number(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      PlatButton(
                          appState: context.watch<UserViewModel>().appState,
                          // color: _formKey.currentState!.validate()?null :AppColor.g500,
                          title: "Reset Password",
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              sendMail();
                            }
                          }),
                      SizedBox(
                        height: size.height * 0.05,
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

  void sendMail() {
    var viewModel = context.read<UserViewModel>();
    viewModel
        .resetPassword(_email.text, _password.text, _token.text)
        .then((value) {
      if (value == true) {
        RandomFunction.toast("You have successfully reset your password");
        nav(context, Login(), remove: true);
      }
    });
  }
}
