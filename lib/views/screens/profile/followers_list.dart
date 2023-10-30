import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/users_card.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';

class FollowersList extends StatefulWidget {
  final int index;
  final String id;
  const FollowersList({Key? key, required this.index, required this.id})
      : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  List<UserProfile> following = [];
  List<UserProfile> followers = [];
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Column(
        children: [
          TabBar(
            controller: controller,
            tabs: const [
              Tab(
                text: "Following",
              ),
              Tab(
                text: "Followers",
              )
            ],
            // padding: EdgeInsets.only(right: 100.w),
            labelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
            unselectedLabelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
            labelColor: AppColor.textColor,
            unselectedLabelColor: AppColor.g60,
            indicatorColor: AppColor.p300,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 1.w,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 7.w),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("following")
                        .doc("users")
                        .collection(widget.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.docs.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: EmptyContentContainer(),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var encode = json.encode(
                                      snapshot.data!.docs[index].data());
                                  Map<String, dynamic> user =
                                      jsonDecode(encode);
                                  var data = UserProfile.fromJson(user);
                                  return UserCard(
                                    data: data,
                                    id: widget.id,
                                  );
                                });
                      }
                      return const Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: EmptyContentContainer(),
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("followers")
                        .doc("users")
                        .collection(widget.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.docs.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: EmptyContentContainer(),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var encode = json.encode(
                                      snapshot.data!.docs[index].data());
                                  Map<String, dynamic> user =
                                      jsonDecode(encode);
                                  var data = UserProfile.fromJson(user);
                                  return UserCard(
                                    data: data,
                                    id: widget.id,
                                  );
                                });
                      }
                      return const Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: EmptyContentContainer(),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        TabController(length: 2, vsync: this, initialIndex: widget.index);
    Future.delayed(const Duration(milliseconds: 50), () {
      //getData();
    });
  }

  void getData() {
    FirebaseFirestore.instance
        .collection("following")
        .doc("users")
        .collection(widget.id)
        .get()
        .then((value) {});

    FirebaseFirestore.instance
        .collection("following")
        .doc("users")
        .collection(widget.id)
        .get()
        .then((value) {});
  }
}
