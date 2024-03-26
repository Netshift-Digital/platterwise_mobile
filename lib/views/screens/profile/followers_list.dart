import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/users_card.dart';

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
                following.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: EmptyContentContainer(),
                      )
                    : ListView.builder(
                        itemCount: following.length,
                        itemBuilder: (context, index) {
                          return UserCard(
                            data: following[index],
                            id: widget.id,
                          );
                        }),
                followers.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: EmptyContentContainer(),
                      )
                    : ListView.builder(
                        itemCount: followers.length,
                        itemBuilder: (context, index) {
                          return UserCard(
                            data: followers[index],
                            id: widget.id,
                          );
                        })
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller =
        TabController(length: 2, vsync: this, initialIndex: widget.index);
    Future.delayed(const Duration(milliseconds: 50), () {
      getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller = null;
  }

  getData() async {
    var model = context.read<VBlogViewModel>();
    var res = await model.getUserFollowers(widget.id, postIndex: 1);
    var res2 = await model.getUserFollowing(widget.id, postIndex: 1);
    if (res != null) {
      setState(() {
        followers = res;
      });
    }
    if (res2 != null) {
      setState(() {
        following = res2;
      });
    }
  }
}
