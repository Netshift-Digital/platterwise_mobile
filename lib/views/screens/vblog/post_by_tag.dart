import 'package:flutter/material.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';

class PostByTag extends StatefulWidget {
 final String tag;
  const PostByTag({Key? key, required this.tag}) : super(key: key);

  @override
  State<PostByTag> createState() => _PostByTagState();
}

class _PostByTagState extends State<PostByTag> {
  List<Post>? searchResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context,
          title: Text(widget.tag,
            style: AppTextTheme.h4.copyWith(
              fontSize: 20,
              color: AppColor.p200
            ),
      )),
      body:Padding(
        padding: const EdgeInsets.only(left: twenty,right: twenty),
        child: searchResult==null?
           const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor.p200),
              ),
            )
            :searchResult!.isEmpty?
           const EmptyContentContainer()
            :
        ListView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: searchResult!.length,
            itemBuilder: (context,index) {
              var data =  searchResult![index];
              return  TimelinePostContainer(data);
            }
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 50),(){
      context.read<VBlogViewModel>().getPostByTag(widget.tag)
          .then((value){
            if(mounted){
              setState(() {
                searchResult=value;
              });
            }
      });
    });
  }
}
