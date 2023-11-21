import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/text-theme.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/enum/app_state.dart';
import 'package:platterwave/utils/nav.dart';
import 'package:platterwave/utils/size_config/size_config.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/view_models/pageview_model.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/screens/search/search_screen.dart';
import 'package:platterwave/views/screens/vblog/create_post/create_post.dart';
import 'package:platterwave/views/screens/vblog/following_tab.dart';
import 'package:platterwave/views/screens/vblog/notification.dart';
import 'package:platterwave/views/screens/vblog/recommended_tab.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';

class Timeline extends StatefulWidget {
  final ScrollController scrollController = ScrollController();
  Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final searchTextController = TextEditingController();
  int _postIndex = 0;
  int tabIndex = 0;
  bool postEnd = false;
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
            child: const Text(
              'Community',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFCCCCCC)),
            )),
        // SvgPicture.asset(
        //   "assets/icon/platterwise_logo.svg",
        //   height: 15.h,
        //   width: 161.w,
        // )),
        actions: [
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () {
              nav(context, const SearchScreen());
            },
            child: SvgPicture.asset('assets/icon/search-normal.svg'),
          ),
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
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          //  controller: scrollController,
          headerSliverBuilder: (context, scroll) {
            return [
              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 10,
              )),
              SliverAppBar(
                backgroundColor: AppColor.g0,
                elevation: 0.0,
                pinned: true,
                toolbarHeight: 60,
                //collapsedHeight: 0,
                expandedHeight: 0,
                primary: false,
                automaticallyImplyLeading: false,
                title: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: TabBar(
                        onTap: (index) {
                          if (mounted) {
                            widget.scrollController.jumpTo(0);
                            setState(() {
                              tabIndex = index;
                            });
                            getPost(restart: true);
                          }
                        },
                        tabs: const [
                          Tab(
                            text: "Following",
                          ),
                          Tab(
                            text: "Recommended",
                          )
                        ],
                        // padding: EdgeInsets.only(right: 100.w),
                        labelStyle: AppTextTheme.h6.copyWith(fontSize: 18),
                        unselectedLabelStyle:
                            AppTextTheme.h6.copyWith(fontSize: 18),
                        labelColor: AppColor.textColor,
                        unselectedLabelColor: AppColor.g60,
                        indicatorColor: AppColor.p300,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 1.w,
                        indicatorPadding: EdgeInsets.symmetric(horizontal: 7.w),
                      ),
                    ),
                    model.postAppState == AppState.busy
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey[200]!,
                              valueColor:
                                  const AlwaysStoppedAnimation(AppColor.p200),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              )
            ];
          },
          body: Consumer<VBlogViewModel>(
            builder: (context, vBlogModel, child) {
              final posts = vBlogModel.allposts;
              return posts.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: EmptyContentContainer(
                          errorText: "No Posts here yet",
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      controller: widget.scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        var data = posts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TimelinePostContainer(data),
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        getPost(restart: true);
      }
    });
    if (mounted) {
      widget.scrollController.addListener(() {
        var model = context.read<PageViewModel>();
        if (widget.scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          model.hideBottomNavigator();
        } else {
          model.showBottomNavigator();
        }
        if (widget.scrollController.position.pixels ==
            widget.scrollController.position.maxScrollExtent) {
          getPost(restart: false);
        }
      });
    }
  }

  void getPost({bool restart = false}) async {
    var model = context.read<VBlogViewModel>();
    if (restart) {
      _postIndex = 0;
      postEnd = false;
    }
    if (postEnd == false) {
      _postIndex = _postIndex + 1;
      postEnd = tabIndex == 0
          ? await model.getPost(restart: restart, postIndex: _postIndex)
          : await model.getRecPost(restart: restart, postIndex: _postIndex);
    }
  }
}
