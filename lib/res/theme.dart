import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme{

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    fontFamily: "Satoshi"
  );

}


const kOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light
);