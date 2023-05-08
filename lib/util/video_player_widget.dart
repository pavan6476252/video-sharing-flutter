import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
   late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControlsOnInitialize: true,
      showControls: true,
      allowFullScreen: true,
      fullScreenByDefault: false,
      aspectRatio: 16/9,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        bufferedColor: Colors.white,
      ),
     
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }
}
  // late VideoPlayerController _controller;
  // bool _isFullScreen = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.network(widget.videoUrl)
  //     ..initialize().then((_) {
  //       setState(() {});
  //     });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Material(
  //     type: MaterialType.transparency,
  //     child: Container(
  //       alignment: Alignment.center,
  //       child: AspectRatio(
  //         aspectRatio: _controller.value.aspectRatio,
  //         child: Stack(
  //           alignment: Alignment.bottomCenter,
  //           children: [
  //             VideoPlayer(_controller),
  //             _buildControls(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildControls() {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Align(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             _buildPlayPauseButton(),
  //             _buildFullScreenButton(),
  //           ],
  //         ),
  //       ),
  //       _buildProgressBar(),
  //     ],
  //   );
  // }

  // Widget _buildProgressBar() {
  //   return VideoProgressIndicator(
  //     _controller,
  //     allowScrubbing: true,
  //     colors: VideoProgressColors(
  //       playedColor: Colors.red,
  //       bufferedColor: Colors.grey,
  //       backgroundColor: Colors.white,
  //     ),
  //   );
  // }

  // Widget _buildPlayPauseButton() {
  //   return IconButton(
  //     icon: Icon(
  //       _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.white,
  //     ),
  //     onPressed: () {
  //       setState(() {
  //         _controller.value.isPlaying
  //             ? _controller.pause()
  //             : _controller.play();
  //       });
  //     },
  //   );
  // }

  // Widget _buildFullScreenButton() {
  //   return IconButton(
  //     icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,color:Colors.white),
  //     onPressed: () {
  //       setState(() {
  //         _isFullScreen = !_isFullScreen;
  //         if (_isFullScreen) {
  //           _enterFullScreen();
  //         } else {
  //           _exitFullScreen();
  //         }
  //       });
  //     },
  //   );
  // }

  // void _enterFullScreen() {
  //   _controller.pause();
  //   _controller.seekTo(Duration.zero);
  //   _controller.play();
  //   SystemChrome.setEnabledSystemUIOverlays([]);
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  //   setState(() {});
  // }

  // void _exitFullScreen() {
  //   _controller.pause();
  //   _controller.seekTo(Duration.zero);
  //   _controller.play();
  //   SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  //   setState(() {});
  //   ;
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }
