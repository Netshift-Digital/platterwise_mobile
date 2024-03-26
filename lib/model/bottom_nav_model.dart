import 'package:flutter/material.dart';

class BottomNavigationModel{
  String title;
  String icon;
  Widget screen;

  BottomNavigationModel({
    required this.title,
    required this.icon,
    required this.screen
  });
}