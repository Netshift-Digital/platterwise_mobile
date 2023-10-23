import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/constant/screen_constants.dart';
import 'package:platterwave/data/local/local_storage.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/auth/onboarding_screen.dart';
import 'package:platterwave/views/screens/bottom_nav/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDB4E2E),
      body: Center(
        child: SvgPicture.asset(
          "assets/images/PW-logo - svg.svg",
          height: 24,
          width: 140,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    permission();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FlutterNativeSplash.remove();
      if (LocalStorage.isFirstTime() == true) {
        nav(context, const Onboarding(), remove: true);
        LocalStorage.changeIsFirstTime(false);
      } else {
        isLoginValid().then((value) {
          print("The value is $value");
          if (value == true) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNav()));
          } else {
            nav(context, Login(), remove: true);
          }
        });
      }
    });
  }

  Future<bool> isLoginValid() async {
    String loginTimeString = LocalStorage.getLoginTime();
    if (loginTimeString.isEmpty) {
      return false;
    }
    DateTime loginTime = DateTime.parse(loginTimeString);
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(loginTime);
    print("The difference is $difference");
    return difference.inSeconds <= AppStrings.loginTime;
  }

  void permission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      provisional: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      sound: true,
    );
    NotificationSettings set = await messaging.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {
      print('User declined or has not accepted permission');
    }
  }
}

//Masterkeys1$
//chi30037838
