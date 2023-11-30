import 'package:flutter/material.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';

class UserCard extends StatefulWidget {
  final UserProfile data;
  final String id;

  UserCard({Key? key, required this.data, required this.id}) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    checkIsFollowing();
  }

  checkIsFollowing() async {
    var blogModel = context.read<VBlogViewModel>();
    isFollowing = await blogModel.getIsFollowed(widget.id);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ListTile(
      onTap: () {
        nav(
          context,
          ViewUserProfileScreen(
            id: widget.data.userId.toString(),
          ),
        );
      },
      leading: ImageCacheCircle(
        widget.data.profileUrl,
        height: 42,
        width: 42,
      ),
      title: Text(
        widget.data.fullName,
        style: AppTextTheme.h3.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        "@${widget.data.username}",
        style: AppTextTheme.h3.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xffB1B1B1),
        ),
      ),
      trailing: isFollowing == false
          ? PlatButton(
              title: "Follow",
              padding: 0,
              textSize: 14,
              color: isFollowing ? AppColor.g700 : AppColor.p200,
              onTap: () {
                var main_user = context.read<UserViewModel>().user;
                var blogModel = context.read<VBlogViewModel>();
                blogModel
                    .followUser(widget.id, main_user!, widget.data)
                    .then((value) {
                  if (value) {
                    if (mounted) {
                      setState(() {
                        isFollowing = true;
                      });
                    }
                  }
                });
              },
              width: 95.w,
              height: 38.h,
            )
          : SizedBox(),
    );
  }
}
