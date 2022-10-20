import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platterwave/constant/index.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/locator.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/auth/register.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platterwave/views/screens/auth/login.dart';
import 'package:platterwave/views/screens/bottom_nav/bottom_nav.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light));
  setupLocator();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>PageViewModel()),
      ChangeNotifierProvider(create: (_)=>UserViewModel()),
      ChangeNotifierProvider(create: (_)=>VBlogViewModel()),
    ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainPage(),
      ),
    );
  }
}


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, user){
          if(user.hasData){
            return const BottomNav();
          }if (user.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else{
            return Register();
          }
        }
    );
  }
}


