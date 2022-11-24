
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platterwave/constant/post_type.dart';
import 'package:platterwave/model/request_model/post_data.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/random_functions.dart';
import 'package:platterwave/view_models/user_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/dialog/alert_dialog.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String type = PostType.text;
  final ImagePicker _picker = ImagePicker();
  XFile? path;
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var model = context.watch<VBlogViewModel>();
    var user = context.watch<UserViewModel>().user!.userProfile;
    return WillPopScope(
      onWillPop: ()async{
        cancel(context);

        return false;
      },
      child: Scaffold(
        floatingActionButton: SafeArea(
          child: Row(
            children: [
              const SizedBox(width: 30,),
              vidImage(
                image:"assets/icon/gallery.svg",
                text:"Pictures",
                onTap:(){
                  pickImage();
                }
              ),
              const SizedBox(width: 16,),
              vidImage(
                  image:"assets/icon/video-square.svg",
                  text:"Videos",
                  onTap:(){
                    pickVideo();
                  }
              )
            ],
          ),
        ),
        appBar: AppBar(
          systemOverlayStyle: kOverlay,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: (){
              cancel(context);
            },
              child: const Icon(Icons.clear,color: AppColor.g800,size: 30,)),
          actions: [
            Row(
              children: [
                model.appState==AppState.busy?
                   const SizedBox(
                      height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                           strokeWidth: 5,
                           valueColor: AlwaysStoppedAnimation(AppColor.p300),
                        )):
                PlatButton(
                  padding: 3,
                    height: 32,
                    width: 90,
                    textSize: 14,
                    title: "Post",
                    radius: 6,
                    onTap: (){
                    if(model.appState==AppState.idle){
                      createPost(context);
                    }

                    }
                ),
                const SizedBox(width:sixteen,),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageCacheCircle(user.profileUrl,
                    height: forty,
                    width: forty,),
                   const SizedBox(width:twentyFour ,),
                    Expanded(
                            child: TextFormField(
                              controller: commentController,
                            maxLines: null,
                            minLines: null,
                            decoration: const InputDecoration(
                            hintText: 'Share your ideas here!',
                            border: InputBorder.none
                          ),
                        )
                    )
                  ],
                ),
               const SizedBox(height: 50,),
                path==null?const SizedBox():type==PostType.video?videoWid():imageList()
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget  vidImage({required String image, required String text, required  Function() onTap}) {

    return GestureDetector(
      onTap:onTap ,
      child: Row(
        children: [
          SvgPicture.asset(image),
          const SizedBox(width:2 ,),
          Text(text,style: AppTextTheme.h4.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500
          ),),
        ],
      ),
    );

}

  void pickImage({ImageSource imageSource =ImageSource.camera }) async{
    final List<XFile>? selectedImages = await _picker.pickMultiImage(
      imageQuality: 50
    );
    if(selectedImages!=null){
      setState(() {
        type=PostType.image;
        path = selectedImages.first;
      });

    }

  }

  void pickVideo({ImageSource imageSource =ImageSource.gallery })async{
    final XFile? selectedVideo = await _picker.pickVideo(
        source: imageSource,
      maxDuration: const Duration(seconds: 60)
    );
    if(selectedVideo!=null){
      setState(() {
        path=selectedVideo;
        type=PostType.video;
      });
    }
  }
  Widget  videoWid() {
    return Container(
      height:200 ,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: AppColor.p300,
          borderRadius: BorderRadius.circular(15),
          shape: BoxShape.rectangle
      ),
      child:const ImageCacheR("https://www.balmoraltanks.com/images/common/video-icon-image.jpg"),
    );
  }

Widget  imageList() {
    return path==null?const SizedBox():Padding(
      padding:const EdgeInsets.symmetric(horizontal:6 ),
      child: Container(
        height:200 ,
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            image: DecorationImage(
                image: FileImage(File(path!.path)),
                fit: BoxFit.cover
            )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                   path = null;
                  });
                },
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xff4F4F4F),
                  child:  Icon(Icons.clear,color: Colors.white,size: 13,),
                ),
              ),
            )
          ],
        ),
      ),
    );
}

  void cancel(BuildContext context) {
    CustomAlert(context: context,
        title: "Confirm to leave ",
        body:"Are you sure you want to delete your post.",
        onTap:() {
          Navigator.pop(context);
        }
    ).show();
  }

  void createPost(BuildContext context) {
    var model = context.read<VBlogViewModel>();
    var uid = context.read<UserViewModel>().user!.userProfile.userId;
    if(commentController.text.isNotEmpty){
      PostData postData =
      PostData(
         userId: int.parse(uid),
          contentPost: commentController.text,
          contentType: type,
          contentUrl: '');
      model.createPost(postData,
          imagePath: path==null?null:path!.path).
      then((value){
        model.getPost();
       Navigator.pop(context);
      });
    }else{
      RandomFunction.toast("Enter a text");
    }
  }
}
