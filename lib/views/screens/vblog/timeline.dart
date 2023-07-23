import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/vblog/notification.dart';
import 'package:platterwave/views/screens/vblog/create_post/create_post.dart';
import 'package:platterwave/views/screens/vblog/trending_page.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:platterwave/views/widget/containers/sub_categories_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final searchTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool hideFab = false;
  @override
  Widget build(BuildContext context) {
    var model = context.read<VBlogViewModel>();
    SizeConfig.init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.p300,
        child: SvgPicture.asset('assets/icon/post.svg'),
        onPressed: () {
          nav(context, const CreatePost());
        },
      ),
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: kOverlay,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 28, maxWidth: 300),
            child: SvgPicture.asset(
              "assets/icon/platterwise_logo.svg",
              height: 15.h,
              width: 161.w,
            )),
        actions: [
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
              onTap: () {
                nav(context, const NotificationActivity());
              },
              child: SvgPicture.asset("assets/icon/notification-bing.svg")),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await model.getPost(restart: true);
        },
        child: SingleChildScrollView(
          //physics: const BouncingScrollPhysics(),
          controller: scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    PlatButton(
                        title: "Trending",
                        height: 39,
                        width: 84,
                        textSize: 15,
                        padding: 4,
                        textColor: AppColor.g800,
                        color: AppColor.g30,
                        onTap: () {}),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        SubCategoriesContainer(
                          onTap: () {
                            nav(context,
                                const TrendingPage(basedOn: 'baselike'));
                          },
                          title: 'Most Liked',
                          image: "assets/images/likes.png",
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SubCategoriesContainer(
                          onTap: () {
                            nav(context,
                                const TrendingPage(basedOn: 'basecomment'));
                          },
                          title: 'Most Commented ',
                          image: "assets/images/comments.png",
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: context.watch<VBlogViewModel>().posts.length,
                  itemBuilder: (context, index) {
                    var data = model.posts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      //child: Text('chisom'),
                      child: TimelinePostContainer(data),
                    );
                  }),
              model.postAppState == AppState.busy
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[200]!,
                        valueColor: const AlwaysStoppedAnimation(AppColor.p200),
                      ),
                    )
                  : const SizedBox()
            ], //D88232FD
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPost(restart: true);
    });
    scrollController.addListener(() {
      var model = context.read<PageViewModel>();
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        model.hideBottomNavigator();
      } else {
        model.showBottomNavigator();
      }
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getPost(restart: false);
      }
    });
  }

  void getPost({bool restart = false}) {
    var model = context.read<VBlogViewModel>();
    model.getPost(restart: false);
  }
}
