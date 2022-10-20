import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/vblog/comment.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:provider/provider.dart';

class PostDetails extends StatefulWidget {
  final Post post;
  const PostDetails({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  List<UsersComment> comments = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getComment();
        },
      ),
      appBar:AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ) ,
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 15),
        child: SingleChildScrollView(
         physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               TimelinePostContainer(widget.post,tap: false,),
              ListView.builder(
                itemCount: comments.length,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                  UsersComment data = comments[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const SizedBox(height: 10,),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(34),
                              child: ImageCacheR(
                                data.profileUrl,
                                height: 35,
                                width: 35,
                              ),
                            ),
                            const SizedBox(width: 12,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                 data.username,
                                  style: AppTextTheme.h3.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 3,),
                                Text(RandomFunction.date(data.timestamp.toString()).yMMMdjm,
                                style: AppTextTheme.h4.copyWith(
                                  fontSize:12
                                ),),
                                const SizedBox(height: 12,),
                              ],
                            ),
                            const Spacer(),
                            SvgPicture.asset("assets/icon/option.svg")
                          ],
                        ),
                        Row(
                          children: [
                            Text("Replying to ",
                              style: AppTextTheme.h4.copyWith(
                                  fontSize:14,
                                  color: AppColor.g500,
                                  fontWeight: FontWeight.w700
                              ),),
                            Text("@${widget.post.username}",
                              style: AppTextTheme.h4.copyWith(
                                  fontSize:14,
                                  color: AppColor.p200,
                                  fontWeight: FontWeight.w700
                              ),),
                          ],
                        ),
                        const SizedBox(height: 12,),
                        Text(data.comment,
                          style: AppTextTheme.h4.copyWith(
                              fontSize:16,
                              color: AppColor.g900,
                              fontWeight: FontWeight.w400
                          ),),
                        const SizedBox(height: 12,),
                        const Divider(
                          color: AppColor.g50,
                          thickness: 1,
                        ),
                        const SizedBox(height: 12,),
                      ],
                    );
                  },

              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getComment();
    Future.delayed(const Duration(milliseconds: 40),(){
      getComment();
    });
  }

  void getComment() {
    var model = context.read<VBlogViewModel>();
    model.getComment(int.parse(widget.post.postId))
    .then((value){
      setState(() {
        comments=value;
      });
    });
  }
}
