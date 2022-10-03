import 'package:flutter/material.dart';
import 'package:platterwave/views/widget/containers/timeline_post_container.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context,index) {
          return const TimelinePostContainer();
        }
      ),
    );
  }
}
