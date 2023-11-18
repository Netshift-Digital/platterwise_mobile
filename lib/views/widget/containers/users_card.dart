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

class UserCard extends StatelessWidget {
  final UserProfile data;
  final String id;
  const UserCard({Key? key, required this.data, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    var blogModel = context.watch<VBlogViewModel>();
    var isFollower = blogModel.getIsFollowed(data.userId.toString());
    return ListTile(
      onTap: () {
        nav(
            context,
            ViewUserProfileScreen(
              id: data.firebaseAuthID,
            ));
      },
      leading: ImageCacheCircle(
        data.profileUrl,
        height: 42,
        width: 42,
      ),
      title: Text(
        data.fullName,
        style: AppTextTheme.h3.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        "@${data.username}",
        style: AppTextTheme.h3.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xffB1B1B1)),
      ),
      trailing: FutureBuilder<bool?>(
          future: isFollower,
          builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
            return PlatButton(
              title: snapshot.data! ? "Remove" : "Follow",
              padding: 0,
              color: snapshot.data! ? AppColor.g700 : AppColor.p200,
              textSize: 14,
              onTap: () {
                if (snapshot.data!) {
                  blogModel.unFollowUser(
                    data.userId.toString(),
                  );
                } else {
                  var user = context.read<UserViewModel>().user;
                  blogModel.followUser(data.userId.toString(), user!, data);
                }
              },
              width: 103.w,
              height: 37.h,
            );
          }),
    );
  }
}
