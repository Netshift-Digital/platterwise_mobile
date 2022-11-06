import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/vblog/user_search.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/profile/view_user_profile_screen.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/sub_categories_container.dart';
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
  List<SearchResultElement> searchResult =[];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              onFieldSubmitted: (e){
                if(searchController.text.length>2){
                  context.read<VBlogViewModel>().searchUser(searchController.text)
                      .then((value){
                    if(value!=null){
                      setState(() {
                        searchResult=value;
                      });
                    }
                  });
                }
              },
              hintText: "Search for a post or people",
                prefixIcon: SvgPicture.asset("assets/icon/search-normal.svg"),
              suffixIcon: GestureDetector(
                onTap: (){
                  searchController.clear();
                },
                  child: SvgPicture.asset("assets/icon/cancel.svg")),
            ),
            SizedBox(height: 43.h,),
            Expanded(
              child: searchResult.isEmpty?const Center(
                child: EmptyContentContainer(

                ),
              ):
              ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context,index){
                    var data = searchResult[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        onTap: (){
                          nav(context, ViewUserProfileScreen(id: data.firebaseAuthId,));
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Text(data.username),
                        leading:  ImageCacheCircle(
                         data.profileUrl,
                          height: 70,
                          width: 70,
                        ),
                        //leading: ,
                      ),
                    );
                  }
              ),
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
}