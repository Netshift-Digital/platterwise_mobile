import 'package:flutter/material.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/vblog/post_details.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:provider/provider.dart';

class SharedPost extends StatefulWidget {
  final String id;
  const SharedPost({Key? key, required this.id}) : super(key: key);

  @override
  State<SharedPost> createState() => _SharedPostState();
}

class _SharedPostState extends State<SharedPost> {
  Post? post;
  String message = "";
  @override
  Widget build(BuildContext context) {
    var model = context.watch<VBlogViewModel>();
    return Scaffold(
      appBar: post == null ? appBar(context) : null,
      body: post != null
          ? PostDetails(post: post!)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(),
                model.appState == AppState.busy
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColor.p200),
                      )
                    : const EmptyContentContainer(
                        errorText: 'Post not Found',
                      )
              ],
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 20), () {
      getPost();
    });
  }

  void getPost() {
    var model = context.read<VBlogViewModel>();
    model.getMyPostById(widget.id).then((value) {
      if (value != null) {
        setState(() {
          print("This is the post $value");
          print("This is the post id ${widget.id}");
          post = value;
          message = "Post not Found";
        });
      }
    });
  }
}
