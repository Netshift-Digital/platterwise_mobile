import 'package:flutter/material.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/auth/register.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';

class SignInSignUp extends StatefulWidget {
  const SignInSignUp({Key? key}) : super(key: key);

  @override
  State<SignInSignUp> createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(),
            const Text('Welcome\nto Tabilli',style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 40
            ),),
            const SizedBox(height: 80,),
            PlatButton(
                title: "Login",
                onTap: (){
                  nav(context, Login());
                }
            ),
            const SizedBox(height: 20,),
            PlatButton(
              color: Colors.grey[100],
                title: "Sign up",
                textColor: AppColor.g900,
                onTap: (){
                nav(context, const Register());
                }
            )
          ],
        ),
      ),
    );
  }
}
