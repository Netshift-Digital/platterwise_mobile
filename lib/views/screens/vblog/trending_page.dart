import 'package:flutter/material.dart';
import 'package:platterwave/view_models/vblog_veiw_model.dart';
import 'package:platterwave/views/widget/appbar/appbar.dart';
import 'package:platterwave/views/widget/containers/empty_content_container.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';
import 'package:provider/provider.dart';

class TrendingPage extends StatefulWidget {
  final String basedOn;
  const TrendingPage({Key? key, required this.basedOn}) : super(key: key);

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<VBlogViewModel>();
    return Scaffold(
      appBar: appBar(context),
      body:model.trendingPost.isEmpty?
         const  Center(child:  EmptyContentContainer())
          :Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
        itemCount: model.trendingPost.length,
        itemBuilder: (context,index) {
              var data =  model.trendingPost[index];
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
     var model = context.read<VBlogViewModel>();
     if(model.baseOn!=widget.basedOn||model.trendingPost.isEmpty){
       model.getTrending(base: widget.basedOn);
     }
    });
  }
}
