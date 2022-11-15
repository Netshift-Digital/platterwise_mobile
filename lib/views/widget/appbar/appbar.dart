import 'package:flutter/material.dart';
import 'package:platterwave/res/theme.dart';

AppBar appBar(BuildContext context,{Widget? title}){
  return AppBar(
    title: title,
    backgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.black),
    systemOverlayStyle: kOverlay,
    elevation: 0,
    automaticallyImplyLeading: true,
  );
}