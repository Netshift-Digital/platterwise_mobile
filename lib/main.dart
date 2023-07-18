import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:disposable_cached_images/disposable_cached_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platterwave/constant/index.dart';
import 'package:platterwave/constant/keys.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/enum/notification_type.dart';
import 'package:platterwave/utils/locator.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/view_models/location_view_model.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/auth/splash.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/screens/restaurant/screen/reservation_details.dart';
import 'package:platterwave/views/screens/vblog/shared_post.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late Directory kDir;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DisposableImages.init();
  Directory tempDir = await getApplicationDocumentsDirectory();
  kDir = await getApplicationSupportDirectory();
  Hive.init(tempDir.path);
  await Hive.openBox("post");
  await Hive.openBox(authKey);
  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
  FlutterError.onError = crashlytics.recordFlutterError;
  // runZonedGuarded(() async {
  //   //await crashlytics.setCrashlyticsCollectionEnabled(false);
  //   FlutterError.onError = crashlytics.recordFlutterError;
  // }, (error, stack) {
  //   crashlytics.recordError(error, stack);
  // });
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light));
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => VBlogViewModel()),
        ChangeNotifierProvider(create: (_) => RestaurantViewModel()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const DisposableImages(MyApp()),
    ),
  );
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
        navigatorKey: navigatorKey,
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
            onDidReceiveLocalNotification: (s, e, r, t) {});
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      //onDidReceiveBackgroundNotificationResponse: _onDidReceiveNotificationResponse
    );
  }

  _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    try {
      if (notificationResponse.payload != null) {
        var data = jsonDecode(notificationResponse.payload ?? "");
        if (data['reserv_id'] != null &&
            FirebaseAuth.instance.currentUser != null) {
          nav(
              navigatorKey.currentState?.context ?? context,
              ReservationDetails(
                id: data['reserv_id'],
              ));
        } else {
          handleNotificationNavigation(data);
        }
      }
    } catch (e) {}
  }
}

void handleNotificationNavigation(Map data) {
  var type = data['type'];
  var id = data['id'];
  BuildContext ctx = navigatorKey.currentState!.context;
  if (type == NotificationType.post.toString()) {
    nav(ctx, SharedPost(id: id));
  } else if (type == NotificationType.user.toString()) {
    nav(
      ctx,
      ViewUserProfileScreen(
        id: id,
      ),
    );
  }
}
