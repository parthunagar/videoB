import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:tapioca/tapioca.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

class FinalDisplayVideo extends StatefulWidget {
  final String? path;
  FinalDisplayVideo(this.path);

  @override
  _FinalDisplayVideoState createState() => _FinalDisplayVideoState(path);
}

class _FinalDisplayVideoState extends State<FinalDisplayVideo> {
  final String? path;

  _FinalDisplayVideoState(this.path);

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(path!))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    print('path : ${widget.path.toString()}');
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(

      body: Center(
        child: _controller.value.isInitialized
            // ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
          ? Container(
            height: h *0.3,
            width: w  ,child: VideoPlayer(_controller))
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
