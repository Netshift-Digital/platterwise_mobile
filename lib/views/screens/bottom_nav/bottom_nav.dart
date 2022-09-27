import 'package:flutter/material.dart';
import 'package:platterwave/model/bottom_nav_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:provider/provider.dart';
import 'package:svg_icon/svg_icon.dart';
import '../../../res/text-theme.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final List<BottomNavigationModel> bottomNav = [
    BottomNavigationModel(
        title: "Home",
        icon: "assest/icon/home-2.svg",
        screen: const SizedBox()
    ),
    BottomNavigationModel(
        title: "Explore",
        icon: "assest/icon/search-normal.svg",
        screen: const SizedBox()),
    BottomNavigationModel(
        title: "Save",
        icon: "assest/icon/bookmarke.svg",
        screen: const SizedBox()
    ),
    BottomNavigationModel(
        title: "Profile",
        icon: "assest/icon/user.svg",
        screen: const SizedBox()
    ),

  ];
  @override
  Widget build(BuildContext context) {
    var pageViewModel = context.watch<PageViewModel>();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 18,
        selectedLabelStyle: AppTextTheme.h5.copyWith(
            fontSize: 9
        ),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.p300,
        unselectedItemColor: AppColor.g700,
        currentIndex: pageViewModel.appIndex,
        onTap: (index) {
          pageViewModel.setIndex(index);
        },
        items: bottomNav.map((e) {
          return BottomNavigationBarItem(
            label:"\n${e.title}",
            icon:e.icon.isEmpty?const Icon(Icons.add_circle):SvgIcon(e.icon),
          );
        }).toList(),
      ),

    );
  }
}

