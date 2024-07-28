import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:tapioca/tapioca.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tapioca/tapioca.dart';
import 'package:video_player/video_player.dart';

//kotlin version : //1.5.21
class MyTopiocaApp extends StatefulWidget {
  File? videoPath;
  MyTopiocaApp({this.videoPath});
  @override
  _MyTopiocaAppState createState() => _MyTopiocaAppState();
}

class _MyTopiocaAppState extends State<MyTopiocaApp> {
  late XFile _video;
  bool isLoading = false;


  _pickVideo() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _video = video;
          var a = video.hashCode;
          var b = video.name;
          var c = video.mimeType;

          print('a : ${a.toString()}');
          print('b : ${b.toString()}');
          print('c : ${c.toString()}');
          // _video = widget.videoPath!.path as XFile;
          print('_video : ${_video.path.toString()}');
          print('videoPath : ${widget.videoPath!.path.toString()}');
          isLoading = true;
        });
      }
    } catch (error) {
      print('_pickVideo ERROR : '+error.toString());
    }
  }

  var imageBitmap,tempDir,path;

  Future? fetchData;
  @override
  void initState() {
    fetchData = getData();
    super.initState();
  }

  Future getData() async {
    try{
      // await _pickVideo();
      tempDir = await getTemporaryDirectory();
      path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
      print('tempDir ===> : '+ tempDir.toString());
      print('path ===>  : '+ path.toString());
    }catch(e){
      print('e1 ===>  : '+e.toString());
    }

    try{
      imageBitmap = (await rootBundle.load("assets/images/tapioca_drink.png")).buffer.asUint8List();
    }
    catch(e){
      print('e2 ===>  : '+e.toString());
    }
    try {
      final tapiocaBalls = [
        TapiocaBall.filter(Filters.pink),
        TapiocaBall.imageOverlay(imageBitmap, 5, 10),
        TapiocaBall.textOverlay("text", 100, 10, 100, Colors.green),
      ];
      // final cup = Cup(Content(_video.path), tapiocaBalls);
      final cup = Cup(Content(widget.videoPath!.path), tapiocaBalls);
      print('cup : ${cup.content.name}');
      print('cup : ${cup.hashCode.toString()}');
      print('cup : ${cup.suckUp(path).runtimeType.toString()}');
      // print('cup : ${tapiocaBalls. .toString()}');

      // var a = await Cup(Content(widget.videoPath!.path), tapiocaBalls).suckUp(widget.videoPath!.path);
      // print('cup : ${a.toString()}');

      cup.suckUp(path).then((value) async {
        print('value ==> : ${value.toString()}');
        print('cup.suckUp path : '+path.toString());
        GallerySaver.saveVideo(path).then((bool? success) {
          print('success : '+success.toString());
        }).catchError((onError){
          print('onError 1 : '+onError.toString());
        });

        // if (currentState != null) {
        // Navigator.push(MaterialPageRoute(builder: (context) => VideoScreen(path)));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoScreen(path)));
        // }
        setState(() {
          isLoading = false;
        });
      }).catchError((onError){
        print('onError 2 : '+onError.toString());
      });
    } catch(e) {
      print("error : ${e.toString()}");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Plugin example app')),
    //   body: Center(
    //       child: isLoading
    //           ? CircularProgressIndicator()
    //           : ElevatedButton(
    //               child: Text("Pick a video and Edit it"),
    //               onPressed: () async {
    //               var imageBitmap,tempDir,path;
    //               print("clicked!");
    //               try{
    //                 // await _pickVideo();
    //                 tempDir = await getTemporaryDirectory();
    //                 path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
    //                 print('tempDir ===> : '+tempDir.toString());
    //                 print('path ===>  : '+path.toString());
    //               }catch(e){
    //                 print('e1 ===>  : '+e.toString());
    //               }
    //
    //               try{
    //                 imageBitmap = (await rootBundle.load("assets/images/tapioca_drink.png")).buffer.asUint8List();
    //               }
    //               catch(e){
    //                 print('e2 ===>  : '+e.toString());
    //               }
    //               try {
    //                 final tapiocaBalls = [
    //                   TapiocaBall.filter(Filters.pink),
    //                   TapiocaBall.imageOverlay(imageBitmap, 300, 300),
    //                   TapiocaBall.textOverlay("text", 100, 10, 100, Color(0xffffc0cb)),
    //                 ];
    //                 // final cup = Cup(Content(_video.path), tapiocaBalls);
    //                 final cup = Cup(Content(widget.videoPath!.path), tapiocaBalls);
    //                 cup.suckUp(path).then((_) async {
    //                   print('cup.suckUp path : '+path.toString());
    //                   GallerySaver.saveVideo(path).then((bool? success) {
    //                     print('success : '+success.toString());
    //                   }).catchError((onError){
    //                     print('onError 1 : '+onError.toString());
    //                   });
    //
    //                   // if (currentState != null) {
    //                     // Navigator.push(MaterialPageRoute(builder: (context) => VideoScreen(path)));
    //                     Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen(path)));
    //                   // }
    //                   setState(() {
    //                     isLoading = false;
    //                   });
    //                 }).catchError((onError){
    //                   print('onError 2 : '+onError.toString());
    //                 });
    //               } catch(e) {
    //                 print("error : ${e.toString()}");
    //               }
    //         },
    //       )),
    // );
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: FutureBuilder(
        future: fetchData,
        builder: (context, snapshot) {
          print('snapshot.data  : ${snapshot.data.toString() }');
         if(snapshot.data == null){
           // return Center(child: LinearProgressIndicator());
           return  Container(
               padding: EdgeInsets.symmetric(horizontal: 20),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Center(child: LinearProgressIndicator(
                     // backgroundColor: Colors.red,
                     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                     // color: Colors.green,
                     // minHeight: 10,
                     // semanticsLabel: (2 * 100.0).toStringAsFixed(1).toString(),
                     // semanticsValue:  (2 * 100.0).toStringAsFixed(1).toString(),
                   )),
                   SizedBox(height: 10),
                   Text('Downloading Video...'),
                 ],
               ));
         }
         else {
           return Container();
         }
         // else{
         //   // return Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen(path)));
         //  return VideoScreen(path);
         // }
        }
      ),
    );
  }

}

class VideoScreen extends StatefulWidget {
  final String path;

  VideoScreen(this.path);

  @override
  _VideoAppState createState() => _VideoAppState(path);
}

class _VideoAppState extends State<VideoScreen> {
  final String path;

  _VideoAppState(this.path);

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    print('path : ${path.toString()}');
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    print('path : ${path.toString()}');
    print('widget.path : ${widget.path.toString()}');
    return Scaffold(
      // appBar: AppBar(title: Text('VIDEO'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
          child: _controller.value.isInitialized
              // ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
              ? Container(
                height: h*0.2,
                width: w,
              child: VideoPlayer(_controller))
              : Container()),

       // SizedBox(height: 20),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );



    // return  Column(
    //   children: [
    //     Center(
    //           child: _controller.value.isInitialized
    //           // ? AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
    //               ? Container(
    //               height: h*0.5,
    //               width: w,
    //               child: VideoPlayer(_controller))
    //               : Container()),
    //
    //     FloatingActionButton(
    //       onPressed: () {
    //         setState(() {
    //           _controller.value.isPlaying ? _controller.pause() : _controller.play();
    //         });
    //       },
    //       child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
    //
    //     )
    //   ],
    // );

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}