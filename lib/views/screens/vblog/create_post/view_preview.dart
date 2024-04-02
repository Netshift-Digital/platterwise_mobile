import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platterwave/res/color.dart';
import 'package:platterwave/res/theme.dart';
import 'package:platterwave/utils/size_config/size_extensions.dart';
import 'package:platterwave/views/widget/button/custom-button.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPreview extends StatefulWidget {
  final XFile videoUrl;
  final Function(Uint8List?) onThumbNailSelected;

  const VideoPreview(
      {Key? key, required this.videoUrl, required this.onThumbNailSelected})
      : super(key: key);

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;
  double _startPosition = 0.0;
  double _endPosition = 0.0;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoUrl.path),
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
      ..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: true,
        );
        setState(() {});
      });
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _captureThumbnail() async {
    if (_controller.value.isInitialized) {
      final Duration position = _controller.value.position;
      setState(() {
        _startPosition = position.inMilliseconds.toDouble();
        _endPosition = (_startPosition + 5000)
            .clamp(0, _controller.value.duration.inMilliseconds.toDouble());
      });
      final Uint8List? thumbnailBytes = await VideoThumbnail.thumbnailData(
        video: widget.videoUrl.path,
        imageFormat: ImageFormat.JPEG,
        quality: 100,
        timeMs: _startPosition.toInt(),
      );

      widget.onThumbNailSelected(thumbnailBytes);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            systemOverlayStyle: kOverlay,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.clear,
                  color: AppColor.g800,
                  size: 30,
                ))),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: _controller.value.isInitialized
                ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Chewie(
                          controller: chewieController,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      PlatButton(
                        title: "Select Thumbnail",
                        onTap: _captureThumbnail,
                      ),
                    ],
                  )
                : CircularProgressIndicator(),
          ),
        ));
  }
}
