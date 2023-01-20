import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:platterwave/model/bottom_nav_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/profile/profile_screen.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/screens/save/save_screen.dart';
import 'package:platterwave/views/screens/search/search_screen.dart';
import 'package:platterwave/views/screens/search/trending.dart';
import 'package:platterwave/views/screens/vblog/shared_post.dart';
import 'package:platterwave/views/screens/vblog/timeline.dart';

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
        icon: "assets/icon/home-2.svg",
        screen: const Timeline()
    ),
    BottomNavigationModel(
        title: "Explore",
        icon: "assets/icon/search-normal.svg",
        screen: const TopTags()),
    BottomNavigationModel(
        title: "Save",
        icon: "assets/icon/bookmark.svg",
        screen: const SaveScreen()
    ),
    BottomNavigationModel(
        title: "Profile",
        icon: "assets/icon/user.svg",
        screen: const ViewUserProfileScreen()
    ),

  ];
  @override
  Widget build(BuildContext context) {
    var pageViewModel = context.watch<PageViewModel>();
    return Scaffold(
      body: bottomNav[pageViewModel.appIndex].screen,
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 50),(){
      getData();
    });

    deepLink();
    setNotification();
    checkNotification();

  }

  void getData() async{
    var userModel = context.read<UserViewModel>();
    var blogModel = context.read<VBlogViewModel>();

  await  userModel.getMyProfile();
   await blogModel.getFollowers();
  await  blogModel.getFollowing();
    await  blogModel.getTopTag();
  }

  void deepLink() {

    FirebaseDynamicLinks.instance.onLink(
        onError: (e)async{
          RandomFunction.toast(e.code);
        },
        onSuccess: (e)async{
          _handelLink(e);
        }

    );
 FirebaseDynamicLinks.instance.getInitialLink().then((e) {
   _handelLink(e);
 });

  }

  _handelLink(PendingDynamicLinkData? e){
    if(e!=null){
      if(e.link.path.isNotEmpty){
        var postId = e.link.path.replaceAll("/", "");
        nav(context, SharedPost(id: postId));
      }
    }
  }

  void setNotification(){
  var user = FirebaseAuth.instance.currentUser;
  if(user!=null){
    FirebaseMessaging.instance.getToken().
    then((value) {
      FirebaseMessaging.instance.subscribeToTopic(user.uid);
    }
    );
  }
  }


  void checkNotification() {
    FirebaseMessaging.onMessage.listen((event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
           const NotificationDetails(
              android: AndroidNotificationDetails(
                '20',
                'learnly',
                importance: Importance.high,
                playSound: true,
                showProgress: true,
                enableVibration: true,
                priority: Priority.high,
                ticker: 'test ticker',
              ),
            ));
      }
    });
  }


}

