import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/vblog/like_user.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';

class PostLike extends StatefulWidget {
  final Post post;
  const PostLike({Key? key, required this.post}) : super(key: key);

  @override
  State<PostLike> createState() => _PostLikeState();
}

class _PostLikeState extends State<PostLike> {
  List<AllLikerDetails> users = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 4,
                  width: 69,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.clear),
                ),
                const Spacer(),
                const Text(
                  'Likes',
                  style: TextStyle(
                    color: Color(0xFF646464),
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var data = users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: (){
                        nav(
                          context,
                          ViewUserProfileScreen(
                            id: widget.post.firebaseAuthId,
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            data.profileURL != null
                                ? ImageCacheCircle(
                                    data.profileURL!,
                                    width: 52,
                                    height: 52,
                                  )
                                : SvgPicture.asset(
                                    'assets/images/avater.svg',
                                    width: 52,
                                    height: 52,
                                  ),
                            const SizedBox(width: 8),
                             Text(
                              data.fullName??'',
                              style: const TextStyle(
                                color: Color(0xFF5C5C5C),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<VBlogViewModel>()
          .getLikeUser(int.parse(widget.post.postId))
          .then((value) {
        if (mounted) {
          setState(() {
            users = value;
          });
        }
      });
    });
  }
}
