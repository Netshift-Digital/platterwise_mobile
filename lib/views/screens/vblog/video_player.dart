import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:platterwave/res/color.dart';
import 'package:video_player/video_player.dart';


class VideoPlay extends StatefulWidget {
  final String url;
  const VideoPlay({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController _controller;
  late  ChewieController chewieController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20,top: 10),
            child: _controller.value.isInitialized
                ? Chewie(
                  controller: chewieController,
                ) : const Center(
                  child:  CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColor.p300),
            ),
                ),
          ),
        )
    );
  }


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.url
      )
      ..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: true,
        );
        setState(() {});
      });

   // _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
