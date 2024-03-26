import 'package:flutter/material.dart';
import 'package:platterwave/res/theme.dart';

AppBar appBar(
  BuildContext context, {
  Widget? title,
  Color appbarColor = Colors.black,
  List<Widget> action = const [],
}) {
  return AppBar(
    title: title,
    actions: action,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: appbarColor),
    systemOverlayStyle: kOverlay,
    elevation: 0,
    automaticallyImplyLeading: true,
  );
}
