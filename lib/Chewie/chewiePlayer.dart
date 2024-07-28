
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {
  // This will contain the URL/asset path which we want to play
  final VideoPlayerController? videoPlayerController;
  final bool? looping;

  ChewieListItem({
    @required this.videoPlayerController,
    this.looping,
  });

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController!,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      // overlay: Center(child: Container(height: 10,width: 10,color: Colors.green)),

      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      placeholder: Container(color: Colors.grey),//while load video
      errorBuilder: (context, errorMessage) {
        return Center(child: Text(errorMessage, style: TextStyle(color: Colors.white)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Chewie(
    //     controller: _chewieController!,
    //   ),
    // );
    return Chewie(
      controller: _chewieController!,
    );
  }

  @override
  void dispose() {
    super.dispose();
    // IMPORTANT to dispose of all the used resources
    widget.videoPlayerController!.dispose();
    _chewieController!.dispose();
  }
}