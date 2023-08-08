import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/model/restaurant/restaurant.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/utils/enum/saerch_type.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/restaurant_view_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/large_restaurant_container.dart';
import 'package:platterwave/views/widget/text_feild/app_textfield.dart';
import 'package:provider/provider.dart';


class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  List<RestaurantData> allRestDetail = [];
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var model = context.watch<RestaurantViewModel>();
    SizeConfig.init(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  if(e.length>2){
                    model.searchRestaurant(e).then((value){
                      if(mounted){
                        setState(() {
                          allRestDetail=value;
                        });
                      }
                    });
                  }
                },
                hintText: "Search for a restaurant",
                prefixIcon: SvgPicture.asset("assets/icon/search-normal.svg"),
                suffixIcon: GestureDetector(
                    onTap: (){
                      searchController.clear();
                    },
                    child:const  Icon(Icons.clear,color: Colors.grey,)
                ),
              ),
              SizedBox(height: 33.h,),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: allRestDetail.length,
                  //physics: const BouncingScrollPhysics(),
                  primary: false,
                  itemBuilder: (BuildContext context, int index) {
                    var data = allRestDetail[index];
                    return LargeRestaurantContainer(
                      restaurantData: data,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 20.h,
                    );
                  },
                ),
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
