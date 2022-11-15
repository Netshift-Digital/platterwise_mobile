import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/auth/signin_signup.dart';
import 'package:platterwave/views/screens/bottom_nav/bottom_nav.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          "assets/icon/platterwise_logo.svg",
          height: 30,
          width: 161,
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 20),(){
      if(FirebaseAuth.instance.currentUser==null){
        nav(context, const SignInSignUp(),remove: true);
      }else{
        context.read<UserViewModel>()
            .getUserProfile(FirebaseAuth.instance.currentUser!.uid)
        .then((value){
          if(value!=null){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=>const BottomNav()));
          }else{
            nav(context, Login(),remove: true);
          }
        });

      }
    });
  }
}
