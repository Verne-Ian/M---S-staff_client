import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  const VideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    // Create a VideoPlayerController and pass the video URL
    VideoPlayerController videoPlayerController =
        VideoPlayerController.network(widget.videoUrl);

    // Initialize the ChewieController
    _chewieController = ChewieController(
      showControls: true,
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    // Dispose of the ChewieController when the widget is disposed
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
