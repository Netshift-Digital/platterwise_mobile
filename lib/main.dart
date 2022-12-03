import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platterwave/constant/index.dart';
import 'package:platterwave/constant/keys.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/locator.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/auth/register.dart';
import 'package:platterwave/views/screens/auth/splash.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:platterwave/views/screens/bottom_nav/bottom_nav.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Directory tempDir = await getApplicationDocumentsDirectory();
  Hive.init(tempDir.path);
  await Hive.openBox("post");
  await Hive.openBox(authKey);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light));
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>PageViewModel()),
      ChangeNotifierProvider(create: (_)=>UserViewModel()),
      ChangeNotifierProvider(create: (_)=>VBlogViewModel()),
    ],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        builder: BotToastInit(),
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: (s,e,r,t){});
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS:initializationSettingsDarwin
        );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}

