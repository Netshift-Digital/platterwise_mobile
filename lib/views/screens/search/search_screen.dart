import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/profile/user_data.dart';
import 'package:platterwave/model/vblog/post_model.dart';
import 'package:platterwave/model/vblog/user_search.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/enum/saerch_type.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/sub_categories_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:platterwave/views/widget/custom/cache-image.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:platterwave/views/widget/tiles/activity/comment_on_post.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../widget/appbar/appbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Post> searchResult=[];
  List<SearchResultElement> searchUserResult =[];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var model = context.watch<VBlogViewModel>();
    SizeConfig.init(context);
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 10.h,),
            AppTextField(
              controller: searchController,
              fillColor: AppColor.g30,
              isSearch: true,
              hasBorder: false,
              onChanged: (e){
                if(searchController.text.length>2){
                  if(model.searchType==SearchType.user){
                    context.read<VBlogViewModel>().searchUser(searchController.text)
                        .then((value){
                      if(value!=null){
                        if(mounted){
                          setState(() {
                            searchUserResult=value;
                          });
                        }

                      }
                    });
                  }else{
                    context.read<VBlogViewModel>().searchPost(searchController.text)
                        .then((value){
                      if(value!=null){
                        if(mounted){
                          setState(() {
                            searchResult=value;
                          });
                        }

                      }
                    });
                  }

                }
              },
              hintText: "Search for a post or people",
                prefixIcon: SvgPicture.asset("assets/icon/search-normal.svg"),
              suffixIcon: GestureDetector(
                onTap: (){
                  filterSheet(model);
                },
                  child:const  Icon(Icons.sort,color: Colors.grey,)
              ),
            ),
            SizedBox(height: 33.h,),
            model.searchType==SearchType.user?
            Expanded(
                child: searchUserResult.isEmpty?const Center(
                  child: EmptyContentContainer(

                  ),
                ): ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: searchUserResult.length,
                    itemBuilder: (context,index) {
                      var data =  searchUserResult[index];
                      return  ListTile(
                        onTap: (){
                          nav(context, const ViewUserProfileScreen());
                        },
                        contentPadding:EdgeInsets.zero ,
                        leading:ImageCacheCircle(data.profileUrl,height: 40,width: 40,) ,
                        title: Text(data.fullName),
                        subtitle: Text(data.username),
                      );
                    }
                )
            ) :Expanded(
              child: searchResult.isEmpty?const Center(
                child: EmptyContentContainer(

                ),
              ): ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchResult.length,
                  itemBuilder: (context,index) {
                    var data =  searchResult[index];
                    return  TimelinePostContainer(data);
                  }
              )
            )
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchController.addListener(() {

    });
  }

  void filterSheet(VBlogViewModel vBlogViewModel) {
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("By post",
                      style: AppTextTheme.large.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),),
                      Checkbox(
                          value: vBlogViewModel.searchType==SearchType.post?true:false,
                          onChanged:(e){
                           if(e==true){
                             vBlogViewModel.setSearchType(SearchType.post);
                             Navigator.pop(context);
                           }
                          }
                      )
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("By User",
                        style: AppTextTheme.large.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),),
                      Checkbox(
                          value: vBlogViewModel.searchType==SearchType.user?true:false,
                          onChanged:(e){
                            if(e==true){
                              vBlogViewModel.setSearchType(SearchType.user);
                              Navigator.pop(context);
                            }
                          }
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
