import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:video_editor_git/Constant/const.dart';
import 'package:video_editor_git/Constant/List/fontFamilyList.dart';
import 'package:video_editor_git/Screen/default_player.dart';

class MovableStackTextItem extends StatefulWidget {
  String? text;
  String? fontFamily;
  var fontColor;
  var textAlign;

  MovableStackTextItem({this.text,this.fontFamily,this.fontColor,this.textAlign});

  @override
  _MovableStackTextItemState createState() => _MovableStackTextItemState();
}

class _MovableStackTextItemState extends State<MovableStackTextItem> {
  double xPosition = 20;
  double yPosition = 20;
  bool? seeTextOperation = false;
  ValueNotifier<Matrix4> notifierTextList = ValueNotifier(Matrix4.identity());

  int? textId, textFamilyId;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    // print('widget.fontFamily : ${widget.fontFamily.toString()}');
    // print('widget.fontColor : ${widget.fontColor.toString()}');

    //ONLY MOVE EMOJI
    //NOT PERFORM SCALE AND ROTATE
    // return Positioned(
    //     top: yPosition,
    //     left: xPosition,
    //     child: GestureDetector(
    //       // this event occure to replace shape wih old shape
    //         onTap: () {
    //         },
    //         // this event occure to drag shape
    //         onPanUpdate: (tapInfo) {
    //           setState(() {
    //             xPosition += tapInfo.delta.dx;
    //             yPosition += tapInfo.delta.dy;
    //           });
    //         },
    //         child: Text(widget.shape!),
    //         // child: CustomPaint(
    //         //   size: Size(50, 50),
    //         //   painter: widget.shape == cTriangle
    //         //     ? Triangle()
    //         //     : widget.shape == cCircle
    //         //     ? Circle()
    //         //     : Squre(50, 50))
    //
    //     ));

    return  MatrixGestureDetector(
      onMatrixUpdate: (m, tm, sm, rm) {   notifierTextList.value = m;   },
      child: AnimatedBuilder(
        animation: notifierTextList,
        builder: (ctx, child) {
          return Transform(
            transform: notifierTextList.value,
            child: Center(
              child: Stack(
                children: [
                  widget.text == '' ? SizedBox() : Container(
                    padding: EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: ()  {
                        setState(() {
                          seeTextOperation = true;
                          // seeFontFamilyView = true;
                        });


                      },
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(
                            color: seeTextOperation == true ? Colors.blue : Colors.transparent,
                            width: 3)),
                        child:  Text(widget.text ?? '',
                          overflow: TextOverflow.visible,
                          textAlign: widget.textAlign ?? TextAlign.center,
                          style: TextStyle(
                            foreground: Paint()
                              ..color = Colors.black
                              ..shader = widget.fontColor == null ? LinearGradient(
                                begin: FractionalOffset.centerLeft,
                                end: FractionalOffset.centerRight,
                                tileMode: TileMode.mirror,
                                stops: [0.0, 1.0],
                                colors: <Color>[Colors.black, Colors.black],
                              ).createShader(Rect.fromCircle(center: Offset(200, 0), radius: 150)) :  widget.fontColor,
                            fontFamily: widget.fontFamily == null ? DefaultTextStyle.of(context).style.fontFamily :  widget.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),

                  seeTextOperation != true
                      ? SizedBox()
                      : Positioned.fill(child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                      ),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            seeTextOperation = false;
                            // setFontFamilyViewFalse();
                            // seeFontFamilyView = false;

                          });
                        },
                        // iconSize: h*0.03,
                        child: Icon(Icons.remove,color: Colors.white,size: h*0.03,),
                      ),
                    ),
                  )),

                  seeTextOperation != true
                      ? SizedBox()
                      : Positioned.fill(child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                      ),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            // seeTextOperation = false;
                            // setFontFamilyViewFalse();
                            // seeFontFamilyView = false;
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
                                              SizedBox(height: h * 0.02),

                                              Container(
                                                height: h*0.4,
                                                child: GridView.builder(
                                                    shrinkWrap: true,
                                                    // physics: NeverScrollableScrollPhysics(),
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        childAspectRatio: 1.2),
                                                    itemCount: FamilyList().fontFamilyData.length,
                                                    itemBuilder: (BuildContext ctx, index) {
                                                      return GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              textFamilyId = index;
                                                              widget.fontFamily = FamilyList().fontFamilyData[index].toString().replaceAll('fonts/', '').replaceAll('.ttf', '');
                                                              // movableTextItems.add(MovableStackTextItem(text: addText, fontColor: linearGradient,fontFamily: setFontFamily));
                                                            });
                                                          },
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(color: textFamilyId == index ? Colors.blue : Colors.transparent, width: 2)),
                                                              alignment: Alignment.center,
                                                              child: Text(
                                                                  'Font Family ${index+1}',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontFamily: FamilyList().fontFamilyData[index].toString().replaceAll('fonts/','').replaceAll('.ttf',''))))
                                                      );
                                                    }),
                                              ),

                                              SizedBox(height: h*0.02),

                                              Container(
                                                height: h*0.2,
                                                color: Colors.grey.withOpacity(0.1),
                                                // child: ListView.builder(
                                                //   shrinkWrap: true,
                                                //   itemCount: FamilyList().colorList.length,
                                                //   scrollDirection: Axis.horizontal,
                                                //   itemBuilder: (context,index){
                                                child: GridView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,// mainAxisExtent: 5,crossAxisSpacing: 5,
                                                        childAspectRatio: 1.2),
                                                    itemCount: FamilyList().colorList.length,
                                                    itemBuilder: (BuildContext ctx, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            textId = index;
                                                            widget.fontColor = LinearGradient(
                                                              begin: FractionalOffset.centerLeft,
                                                              end: FractionalOffset.centerRight,
                                                              tileMode: TileMode.mirror,
                                                              stops: [0.0, 1.0],
                                                              colors: FamilyList().colorList[index]!,//<Color>[Colors.red, Colors.blue],
                                                            ).createShader(Rect.fromCircle(center: Offset(200, 0), radius: 150));
                                                            // createShader(Rect.fromLTWH(0.0, 20.0, 50.0, 20.0));
                                                            Navigator.pop(context);
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
                                              ),

                                              SizedBox(height: h*0.02),

                                              Container(
                                                height: h*0.07,
                                                // width: w,
                                                color: Colors.grey.withOpacity(0.1),
                                                // child: ListView.builder(
                                                //   shrinkWrap: true,
                                                //   scrollDirection: Axis.horizontal,
                                                //   // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                //   // crossAxisCount: 2,// mainAxisExtent: 5,crossAxisSpacing: 5,
                                                //   // childAspectRatio: 1.2),
                                                //   itemCount: FamilyList().fontAlignmentData.length,
                                                //   itemBuilder: (BuildContext ctx, index) {
                                                //     return Container(
                                                //       margin: EdgeInsets.only(right: w*0.1),
                                                //       child: GestureDetector(
                                                //           onTap: (){},
                                                //           child: Icon(FamilyList().fontAlignmentData[index],size: h*0.05)),
                                                //     );
                                                //   }),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: widget.textAlign == TextAlign.left ? Colors.blue : Colors.transparent, width: 2),
                                                        borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: (){
                                                        setState(() {
                                                          widget.textAlign = TextAlign.left;
                                                        });
                                                      },
                                                      child: Icon(Icons.format_align_left,size: h*0.05,)),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: widget.textAlign == TextAlign.center ? Colors.blue : Colors.transparent, width: 2),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            widget.textAlign = TextAlign.center;
                                                          });
                                                        },
                                                        child: Icon(Icons.format_align_center,size: h*0.05,)),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: widget.textAlign == TextAlign.right ? Colors.blue : Colors.transparent, width: 2),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            widget.textAlign = TextAlign.right;
                                                          });
                                                        },
                                                        child: Icon(Icons.format_align_right,size: h*0.05,)),
                                                  ),
                                                ],),
                                              )

                                            ],
                                          );
                                        }
                                    ));
                              },
                            );
                          });
                        },
                        // iconSize: h*0.03,
                        child: Container(
                          // margin:  EdgeInsets.all(4.0),
                          child: Icon(Icons.create,color: Colors.white,size: h*0.03,),
                        ),
                      ),
                    ),
                  )),
                  seeTextOperation != true
                      ? SizedBox()
                      : Positioned.fill(child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                      ),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            widget.text = '';
                            seeTextOperation = false;
                            // setFontFamilyViewFalse();
                            // seeFontFamilyView = false;
                          });
                        },
                        // iconSize: h*0.03,
                        child: Icon(Icons.close,color: Colors.white,size: h*0.03,),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}