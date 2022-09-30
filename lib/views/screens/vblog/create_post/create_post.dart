
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/spacing.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/dialog/alert_dialog.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  bool isImage = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile> images  =[];
  XFile? video;
  @override
  Widget build(BuildContext context) {
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
                image:"assest/icon/gallery.svg",
                text:"Pictures",
                onTap:(){
                  pickImage();
                }
              ),
              const SizedBox(width: 16,),
              vidImage(
                  image:"assest/icon/video-square.svg",
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
                PlatButton(
                  padding: 3,
                    height: 32,
                    width: 90,
                    textSize: 14,
                    title: "Post",
                    radius: 6,
                    onTap: (){

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
                    Container(
                      height: forty,
                      width: forty,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle
                      ),
                    ),
                   const SizedBox(width:twentyFour ,),
                    Expanded(
                            child: TextFormField(
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
                imageList()
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

  void pickImage({ImageSource imageSource =ImageSource.gallery }) async{
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if(selectedImages!=null){
      setState(() {
        isImage=true;
        images.addAll(selectedImages);
      });

    }

  }

  void pickVideo({ImageSource imageSource =ImageSource.gallery })async{
    final XFile? selectedVideo = await _picker.pickVideo(source: imageSource);
    if(selectedVideo!=null){
      setState(() {
        video=selectedVideo;
        isImage=false;
      });
    }
  }

Widget  imageList() {
    return SizedBox(
      height:92 ,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: images.length,
          itemBuilder: (context,index){
             var image = images[index];
             return Padding(
               padding:const EdgeInsets.symmetric(horizontal:6 ),
               child: Container(
                 height:92 ,
                 width: 92,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(6),
                   image: DecorationImage(
                     image: FileImage(File(image.path)),
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
                            images.removeAt(index);
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
}
