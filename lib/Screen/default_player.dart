
import 'dart:io';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:helpers/helpers/misc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tapioca/tapioca.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_editor_git/Component/Draw/painter.dart';
import 'package:video_editor_git/Chewie/chewiePlayer.dart';
import 'package:video_editor_git/Constant/const.dart';
import 'package:video_editor_git/Emojis/emoji.dart';
import 'package:video_editor_git/Constant/List/fontFamilyList.dart';
import 'package:video_editor_git/Screen/finalDisplayVideo.dart';
import 'package:video_editor_git/Component/movableEmojiWidget.dart';
import 'package:video_editor_git/Component/movableTextWidget.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;

class ChewieVideoPlayer extends StatefulWidget {
  File? videoPath;
  String? setFontFamily = '';
  Shader? linearGradient;
  ChewieVideoPlayer({this.videoPath,this.setFontFamily,this.linearGradient});

  @override
  _ChewieVideoPlayerState createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {

  GlobalKey globalKey = GlobalKey();
  double? opacity = 1.0;
  StrokeCap? strokeType = StrokeCap.round;
  double? strokeWidth = 3.0;
  Color? selectedColor = Colors.black;
  bool? seeEmojiView = false;
  bool? seeTextView = false;
  bool? seeFilterView = false,seeDrawView = false;
  var selectedEmoji = '';
  var addText = '';
  List emojiList = [];
  double scale = 0.0;

  int? filterId;
  int? textId, textFamilyId;
  List<Color>? filterLinearGradient = [Colors.transparent,Colors.transparent];
  double xPosition = 20;
  double yPosition = 20;
  String? tempShape;
  List<Widget> movableEmojiItems = [];
  List<Widget> movableTextItems = [];
  ScrollController scrollController = new ScrollController();
  //SAVE VIDEO
  final Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;
  String? _value;
  PainterController? _controller;
  bool _finished = false;
  Color? pickerColor = Colors.white;

  Widget emojiView(){
   return Expanded(
     child: Align(
       alignment: FractionalOffset.bottomCenter,
       child: Container(
         height: 200,
         decoration: BoxDecoration(
             boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 1.0)]
         ),
         child: GridView.builder(
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8, childAspectRatio: 1.1),
             itemCount: FamilyList().emojiList.length,
             itemBuilder: (BuildContext ctx, index) {
               return GestureDetector(
                 onTap: (){
                   setState(() {
                     // selectedEmoji = Emoji.all()[index].toString();
                     // emojiList.add(Emoji.all()[index].toString());
                     // movableEmojiItems.add(MovableStackEmojiItem(emoji: Emoji.all()[index].toString()));

                     selectedEmoji = FamilyList().emojiList[index].toString();
                     emojiList.add(FamilyList().emojiList[index].toString());
                     movableEmojiItems.add(MovableStackEmojiItem(emoji: FamilyList().emojiList[index].toString()));

                     // selectedEmoji = FamilyList().emojiList1[index].toString();
                     // emojiList.add(FamilyList().emojiList1[index].toString());
                     // movableEmojiItems.add(MovableStackEmojiItem(emoji: FamilyList().emojiList1[index].toString()));
                   });
                   // print('I ${Emojis.greenHeart} ${Emojis.directHit}'); // I 💚 🎯
                   // Emoji smile = Emoji.byName('Grinning Face'); // get a emoji by its name
                   // print('Emoji name      : ${smile.name}');
                   // print('all : ${Emoji.all()}');
                   // // Emoji name is Grinning Face
                   // print('Emoji character : ${smile.char}');
                   // // Emoji character is '😀'
                   // print('Emoji category  : ${smile.emojiGroup}');
                   // // EmojiGroup.smileysEmotion group of emoji
                   // print('Emoji sub-group : ${smile.emojiSubgroup}');
                   // // EmojiSubgroup.faceSmiling sub group of emoji
                   // // get an emoji by its character 👱‍♀️
                   // Emoji womanBlond = Emoji.byChar(Emojis.womanBlondHair);
                   // print('womanBlond : ${womanBlond.toString()}');
                   // // make blondy in black
                   // Emoji blondyBlackLady = womanBlond.newSkin(fitzpatrick.dark);
                   // print('blondyBlackLady : ${blondyBlackLady.toString()}');// 👱🏿‍♀️
                   // List<Emoji> emList = Emoji.all(); // list of all Emojis
                   // // disassemble an emoji
                   // List<String> disassembled = Emoji.disassemble(Emojis.mechanic);
                   // print('disassembled : ${disassembled.toString()}');// ['🔧', '🧑']
                   // // assemble some emojis
                   // String assembled = Emoji.assemble([Emojis.man, Emojis.man, Emojis.girl, Emojis.boy]);
                   // print('assembled : ${assembled.toString()}');// 👨‍👨‍👧‍👦️
                   // String blackThumbsUp = '👍';
                   // // modify skin tone of emoji
                   // String witheThumbsUp = Emoji.modify(blackThumbsUp, fitzpatrick.light);
                   // print('witheThumbsUp : ${witheThumbsUp.toString()}');// 👍🏻
                   // // A Woman Police Officer With Brown Skin
                   // String femaleCop =  Emojis.womanPoliceOfficerMediumDarkSkinTone;
                   // // Make that woman to just a Woman Police Officer with no special skin color
                   // String newFemaleCop = Emoji.stabilize(femaleCop);
                   // print('femaleCop : ${femaleCop.toString()} => newFemaleCop : ${newFemaleCop.toString()}');//👮🏾‍♀️ => 👮‍♀️
                   // // gender-neutral
                   // String aCop = Emoji.stabilize(femaleCop, skin: false, gender: true);
                   // print('$femaleCop => $aCop');
                   // print('femaleCop : ${femaleCop.toString()} => aCop : ${aCop.toString()}');//👮🏾‍♀️=> 👮🏾 no gender! still medium dark
                   // final loveEmojis = Emoji.byKeyword('love'); // returns list of lovely emojis :)
                   // print(loveEmojis);
                   // print('loveEmojis : ${loveEmojis.toString()}');
                   // // (🥰, 😍, 😘, 😚, 😙, 🤗, 😻, 😽, 💋, 💌, 💘, 💝, 💖, 💗, 💓, 💞, 💕, ..., 💄, ♾)
                   // final foodCategory =  Emoji.byGroup(EmojiGroup.foodDrink); // returns emojis in Food and Drink group
                   // print('foodCategory : ${foodCategory.toString()}');
                   // // (🍇, 🍈, 🍉, 🍊, 🍋, 🍌, 🍍, 🥭, 🍎, 🍏, 🍐, 🍑, 🍒, 🍓, 🥝, 🍅, 🥥, 🥑, ...)
                   // Iterable<Emoji> moneySubgroupEmojis = Emoji.bySubgroup(EmojiSubgroup.money); // returns emojis in Money subgroup
                   // print('moneySubgroupEmojis : ${moneySubgroupEmojis.toString()}');
                   // // (💰, 💴, 💵, 💶, 💷, 💸, 💳, 🧾, 💹)
                 },
                 child: Container(
                   alignment: Alignment.center,
                   margin: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                   child: Text(FamilyList().emojiList[index].toString() == '' ? '' :  FamilyList().emojiList[index].toString(),style: TextStyle(fontSize: 22),)),
               );
             }),
       ),
     ),
   );
  }

  // Widget fontFamilyView(var h, var w,bool setFontFamilyView) {
  Widget fontFamilyView(var h, var w) {
    return Expanded(child: Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height: h*0.4,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 1.0,
            ),]
        ),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 2.3),
                itemCount: FamilyList().fontFamilyData.length,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: (){
                     setState(() {
                       textFamilyId = index;
                       widget.setFontFamily = FamilyList().fontFamilyData[index].toString().replaceAll('fonts/', '').replaceAll('.ttf', '');
                       MovableStackTextItem().fontFamily = widget.setFontFamily;
                       // movableTextItems.add(MovableStackTextItem(text: addText, fontColor: linearGradient,fontFamily: setFontFamily));
                     });
                    },
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: textFamilyId == index ? Colors.blue : Colors.transparent, width: 2)),
                      alignment: Alignment.center,
                      child: Text(
                        'Font Family ${index+1}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, fontFamily: FamilyList().fontFamilyData[index].toString().replaceAll('fonts/','').replaceAll('.ttf',''))))
                  );
                }),

            Container(
              height: h*0.1,
               // width: w,
              color: Colors.grey.withOpacity(0.1),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: FamilyList().colorList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                return GestureDetector(
                onTap: (){
                  setState(() {
                    textId = index;
                    widget.linearGradient = LinearGradient(
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                      tileMode: TileMode.mirror,
                      stops: [0.0, 1.0],
                      colors: FamilyList().colorList[index]!,//<Color>[Colors.red, Colors.blue],
                    ).createShader(Rect.fromCircle(center: Offset(200, 0), radius: 150));
                    // createShader(Rect.fromLTWH(0.0, 20.0, 50.0, 20.0));
                    MovableStackTextItem().fontColor = widget.linearGradient;
                    // movableTextItems.add(MovableStackTextItem(text: addText, fontColor: linearGradient,fontFamily: setFontFamily));
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 5,top: 5,bottom: 5),
                  width: w * 0.16,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: textId == index ? Colors.blue : Colors.transparent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: FamilyList().colorList[index]!,
                    )
                  ),
                ),
              );
            }),
            )
          ],
        ),
      ),
    ));
  }

  Widget addTextView(var h,var w) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.1),
        child: TextFormField(
          autofocus: true,
          // keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          maxLength: null,
          maxLines: null,
          textAlign: TextAlign.center,
          // textInputAction: TextInputAction.newline,
          // onSaved: (val) {      print('onSaved val : ${val.toString()}');        },
          onFieldSubmitted: (val) {
            print('onFieldSubmitted val : ${val.toString()}');
            setState(() {
              addText = val;
              seeTextView = false;
              //setFontFamily linearGradient
              movableTextItems.add(MovableStackTextItem(text: val.toString(), fontFamily: widget.setFontFamily, fontColor: widget.linearGradient));
            });
          },
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }

  Widget addFilter(var h, var w)  {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          height: h*0.4,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 1.0,
              ),]
          ),
          child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1,
              // mainAxisSpacing: 2
              //   crossAxisSpacing: 3
              //   mainAxisExtent: 0.2
              ),
              itemCount: FamilyList().colorList.length,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      filterId = index;
                      filterLinearGradient = FamilyList().colorList[index]!;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 5,top: 5,bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: filterId == index ? Colors.blue : Colors.transparent  ,width: 2),
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: FamilyList().colorList[index]!,
                        )),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Future<String?> _saveVideo() async {
    var tempDir = await getTemporaryDirectory();
    print('tempDir : ${tempDir.toString()}');
    final path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
    print('path : ${path.toString()}');
    final imageBitmap = (await rootBundle.load("assets/images/tapioca_drink.png")).buffer.asUint8List();
    print('imageBitmap : ${imageBitmap.toString()}');

    try {
      final tapiocaBalls = [
        // TapiocaBall.filter(Filters.pink),
        TapiocaBall.filterFromColor(Colors.transparent.withOpacity(0.5)),
        // TapiocaBall.imageOverlay(imageBitmap, 300, 300),
        // TapiocaBall.textOverlay("1", 100, 10, 100, Color(0xffffc0cb)), // transparent Color(0x00000000)
      ];
      final cup = Cup(Content(widget.videoPath!.path), tapiocaBalls);
      print('cup.content : ${cup.content.name.toString()}');
      cup.suckUp(path).then((val) async {
        // print("path : "+path.toString());
        // print("val : "+val.toString());
        GallerySaver.saveVideo(path).then((bool? success) {
          print("GallerySaver success : " + success.toString());
          if(success == true){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>FinalDisplayVideo(path)));
          }
        });
      });
    } on PlatformException {
      print(" =======> error!!!! <======= ");
    }

  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.videoPath!);
  }

  PainterController newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    controller.opacity = 1.0;
    // controller.drawColor = Colors.transparent;
    // controller.backgroundImage = Image.network('https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png');
    controller.backgroundImage = Image.network('');
    return controller;
  }

  void _pickColor(var h,var w) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: StatefulBuilder(
                builder: (context, setState) {
                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      Container(
                      alignment: Alignment.center,
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c) {
                          pickerColor = c;
                        }
                      )),
                      ElevatedButton(
                        onPressed: () {
                          _controller!.drawColor = pickerColor!;
                          Navigator.pop(context);
                        },
                        child: Text('Pick Color'),
                      ),
                    ],
                  );
                }
            ));
      },
    );
  }

  final _isExporting = ValueNotifier<bool>(false);
  late VideoEditorController controller1;
  final _exportingProgress = ValueNotifier<double>(0.0);
  bool _exported = false;
  String _exportText = "";

  void _exportVideo() async {
    //https://github.com/seel-channel/video_editor/blob/master/example/lib/main.dart
    Misc.delayed(1000, () => _isExporting.value = true);
    //NOTE: To use [-crf 17] and [VideoExportPreset] you need ["min-gpl-lts"] package
    final File? file = await controller1.exportVideo(
      // preset: VideoExportPreset.medium,
      // customInstruction: "-crf 17",
      onProgress: (statics) {
        _exportingProgress.value =
            statics.time / controller1.video.value.duration.inMilliseconds;
      },
    );
    print('file : ${file.toString()}');
    _isExporting.value = false;

    if (file != null)
      {
        print('Video success export');
        _exportText = "Video success export!";
        _exportCover();
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>FinalDisplayVideo(file.path)));
      }
    else
    {
      print('Error on export video');
      _exportText = "Error on export video :(";
    }

    setState(() => _exported = true);
    Misc.delayed(2000, () => setState(() => _exported = false));
  }

  void _exportCover() async {
    setState(() => _exported = false);
    final File? cover = await controller1.exportVideo();

    if (cover != null)
      {
        print('cover.path1 : ${cover.path.toString()}');
        _exportText = "Cover exported! ${cover.path}";
        Navigator.push(context, MaterialPageRoute(builder: (context)=>FinalDisplayVideo(cover.path)));
      }
    else
      {
        print('cover.path2 : ${cover!.path.toString()}');
        _exportText = "Error on cover exportation :(";
      }

    setState(() => _exported = true);
    Misc.delayed(2000, () => setState(() => _exported = false));
  }

  @override
  void initState() {
    controller1 = VideoEditorController.file(widget.videoPath!)
      ..initialize().then((fileValue) => setState(() {
        // print('fileValue  : ${fileValue.toString()}');
      }));
    super.initState();
    _loadVideo();
    _controller = newController();
  }


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    ValueNotifier<Matrix4> notifierEmoji = ValueNotifier(Matrix4.identity());
    ValueNotifier<Matrix4> notifierText = ValueNotifier(Matrix4.identity());
    ValueNotifier<Matrix4> notifierEmojiList = ValueNotifier(Matrix4.identity());
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = newController();
          }),
        ),
      ];
    }
    else {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.brush),
            onPressed: (){
              setState(() {
                _pickColor(h,w);
              });
            }
        ),
        IconButton(
          icon: Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: () {
            if (_controller!.canUndo) _controller!.undo();
          },
        ),
        IconButton(
          icon: Icon(Icons.redo),
          tooltip: 'Redo',
          onPressed: () {
            if (_controller!.canRedo) _controller!.redo();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'Clear',
          onPressed: () => _controller!.clear(),
        ),
        IconButton(
          icon: Icon(Icons.check),
          tooltip: 'Clear',
          onPressed: (){setState(() {
            seeDrawView = false;
          });},
        ),
        // IconButton(
        //     icon: Icon(Icons.check),
        //     onPressed: () async {
        //       setState(() {
        //         _finished = true;
        //       });
        //       Uint8List bytes = await _controller!.exportAsPNGBytes();
        //       Navigator.of(context)
        //           .push(MaterialPageRoute(builder: (BuildContext context) {
        //         return Scaffold(
        //           appBar: AppBar(
        //             title: Text('View your image'),
        //           ),
        //           body: Container(
        //             child: Image.memory(bytes),
        //           ),
        //         );
        //       }));
        //     }),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        bottom: seeDrawView == false
          ? PreferredSize(preferredSize: Size(0,0), child: SizedBox())
          : PreferredSize(preferredSize: Size(w, h*0.12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('        Thikness : '),
                      Flexible(
                        child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            child: Slider(
                              value: _controller!.thickness,
                              onChanged: (value) => setState(() {
                                _controller!.thickness = value;
                              }),
                              min: 1.0,
                              max: 20.0,
                              activeColor: Colors.white,
                              inactiveColor: Colors.black,
                            ));
                        })),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('        Opacity :   '),
                      Flexible(
                        child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Container(
                              child: Slider(
                                value: _controller!.opacity,
                                onChanged: (value) => setState(() {
                                  print('Opacity value : ${value.toString()}');
                                  _controller!.opacity = value;
                                }),
                                min: 0.1,
                                max: 1.0,
                                activeColor: Colors.white,
                                inactiveColor: Colors.black,
                              ));
                            })),

                    ],
                  ),
                ],
              ),
          ),
        actions:  seeDrawView == true
          ? actions :
              [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      if(seeDrawView == true) { seeDrawView = false; }
                      else { seeDrawView = true;  }
                    });
                  },
                  child: Icon(Icons.auto_fix_high),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyEmojiApp()));
                    setState(() {
                      seeDrawView = false;

                      seeTextView = false;
                      seeFilterView = false;
                      if(seeEmojiView == true) { seeEmojiView = false; }
                      else { seeEmojiView = true;  }
                    });
                  },
                  child: Icon(Icons.emoji_emotions),
                ),
                SizedBox(width: 10),
                GestureDetector(
                    onTap: (){
                      setState(() {
                        seeDrawView = false;
                        seeEmojiView = false;
                        seeFilterView = false;
                        if(seeTextView == true) { seeTextView = false; }
                        else { seeTextView = true;  }
                      });
                    },
                    child: Icon(Icons.text_fields),
                  ),
                SizedBox(width: 10),
                GestureDetector(
                    onTap: (){
                      setState(() {
                        seeDrawView = false;
                        seeEmojiView = false;
                        seeTextView = false;
                        if(seeFilterView == true) { seeFilterView = false; }
                        else { seeFilterView = true;  }
                      });
                    },
                    child: Icon(Icons.filter_list_alt),
                  ),
                SizedBox(width: 10),
                GestureDetector(
                    onTap: (){
                      setState(() {
                        _saveVideo();
                      });
                      // _saveVideo().then((outputPath) {
                      //   print('OUTPUT PATH: $outputPath');
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Video Saved successfully')));
                      //   //Navigator.push(context, MaterialPageRoute(builder: (context)=>DownloadVideoFile(finalDownloadVideo: File(outputPath!),)));
                      // });
                    },
                    child: Icon(Icons.save),
                  ),
                SizedBox(width: 10),
              ],),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: h * 0.3,
            child: Stack(
              children: [
                ChewieListItem(videoPlayerController: VideoPlayerController.file(widget.videoPath!)),
                Opacity(
                  opacity: 0.6,
                  child: Container(
                    height: h * 0.3,
                    width: w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.mirror,
                        // stops: [0.0, 1.0],
                        colors: filterLinearGradient!,
                      )))),
                // drawPaint(),

                Painter(_controller!),

                //MULTIPLE EMOJI VIEW
                Stack(children: movableEmojiItems),
                //MULTIPLE TEXT VIEW
                Stack(children: movableTextItems),

                //SINGLE EMOJI VIEW
                // Center(
                //   child: MatrixGestureDetector(
                //     onMatrixUpdate: (m, tm, sm, rm) {
                //       notifierEmoji.value = m;
                //     },
                //     child: AnimatedBuilder(
                //       animation: notifierEmoji,
                //       builder: (ctx, child) {
                //         return Transform(
                //           transform: notifierEmoji.value,
                //           child: Center(
                //             child: Stack(
                //               children: <Widget>[
                //                 Text(
                //                  selectedEmoji == '' ?  "" : selectedEmoji.toString(),
                //                   style:
                //                   TextStyle(fontSize: 55, color: Colors.white,
                //                   // fontFamily: setFontFamily == '' ? DefaultTextStyle.of(context).style.fontFamily : setFontFamily
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),

                //SINGLE TEXT VIEW
                // Center(
                //   child: MatrixGestureDetector(
                //     onMatrixUpdate: (m, tm, sm, rm) {
                //       notifierText.value = m;
                //     },
                //     child: AnimatedBuilder(
                //       animation: notifierText,
                //       builder: (ctx, child) {
                //         return Transform(
                //           transform: notifierText.value,
                //           child: Center(
                //             child: Stack(
                //               children: [
                //                 GestureDetector(
                //                   onTap: (){
                //                     setState(() {
                //                       seeTextView = false;
                //                       seeEmojiView = false;
                //                       if(seeFontFamilyView == true) { seeFontFamilyView = false; }
                //                       else { seeFontFamilyView = true;  }
                //                     });
                //                    },
                //                   child: Text(
                //                     addText == '' ?  "" : addText.toString(),
                //                     style: TextStyle(
                //                         fontSize: 55,
                //                         // background: Paint()..shader = linearGradient,
                //                         foreground: new Paint()
                //                           // ..color = Colors.black
                //                           ..shader = linearGradient,
                //                         fontFamily: setFontFamily == ''
                //                             ? DefaultTextStyle.of(context).style.fontFamily
                //                             : setFontFamily),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),

                // ZoomableWidget(child: Text('sdsd',style: TextStyle(fontSize: 35))),
                seeTextView == true ? addTextView(h,w) : SizedBox(),
              ],),
          ),

          ElevatedButton(
            onPressed: () {
              setState(() {
                _exportVideo();
              });
              // print('emojiList1 : ${FamilyList().emojiList1.length.toString()} => ${FamilyList().emojiList1.toString()}');
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyVideoPickerPageApp()));
            },
            child: Text('Export Video'),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {
          //         controller.start();
          //       },
          //       child: Text('Start'),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         controller.stop();
          //       },
          //       child: Text('Stop'),
          //     ),
          //     ElevatedButton(
          //       onPressed: () async {
          //         // imglib.PngEncoder pngEncoder = new imglib.PngEncoder();
          //         var gif = await controller.export();
          //         print('gif : ${gif.toString()}');
          //         // pngEncoder.encodeImage(gif);
          //         // showDialog(
          //         //   context: context,
          //         //   builder: (context) {
          //         //     return AlertDialog(
          //         //       content: Image.memory(gif),
          //         //     );
          //         //   },
          //         // );
          //       },
          //       child: Text('show recoded video'),
          //     ),
          //   ],
          // ),

          seeEmojiView == true ? emojiView() : SizedBox(),
          seeFilterView == true ? addFilter(h,w) : SizedBox(),
          // seeFilterView == true ? AddFilterWidget() : SizedBox(),
        ],
      ),

      // floatingActionButton:
      //   seeFilterView == true || seeEmojiView == true || seeTextView == true
      //   || seeDrawView == false
      //   ? SizedBox()
      //   : AnimatedFloatingActionButton(
      //         fabButtons: fabOption(),
      //         colorStartAnimation: Colors.blue,
      //         colorEndAnimation: Colors.cyan,
      //         animatedIconData: AnimatedIcons.menu_close,
      //     ),
    );
  }
}
