import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class MovableStackEmojiItem extends StatefulWidget {
  String? emoji;
  MovableStackEmojiItem({this.emoji});

  @override
  _MovableStackEmojiItemState createState() => _MovableStackEmojiItemState();
}

class _MovableStackEmojiItemState extends State<MovableStackEmojiItem> {
  double xPosition = 20;
  double yPosition = 20;
  bool? seeEmojiOperation = false;
  ValueNotifier<Matrix4> notifierEmojiList = ValueNotifier(Matrix4.identity());

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

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
      onMatrixUpdate: (m, tm, sm, rm) {
        notifierEmojiList.value = m;
      },
      child: AnimatedBuilder(
        animation: notifierEmojiList,
        builder: (ctx, child) {
          return Transform(
            transform: notifierEmojiList.value,
            child: Center(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    seeEmojiOperation = true;
                  });
                },
                child: Stack(
                  children: [
                    widget.emoji == '' ? SizedBox() : Container(
                      padding: EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                seeEmojiOperation = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(
                                color: seeEmojiOperation == true ? Colors.blue : Colors.transparent,
                                width: 3)),
                              child:  Text(widget.emoji!,style: TextStyle(fontSize: h*0.16),),
                            ),
                          ),
                        ],
                      ),
                    ),

                    seeEmojiOperation != true ? SizedBox() :  Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                seeEmojiOperation = false;
                              });
                            },
                            // iconSize: h*0.03,
                            child: Icon(Icons.remove,color: Colors.white,size: h*0.03,),
                          ),
                        ),
                      ),
                    ),
                    seeEmojiOperation != true ? SizedBox() : Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                widget.emoji = '';
                                seeEmojiOperation = false;
                              });
                            },
                            // iconSize: h*0.03,
                            child: Icon(Icons.close,color: Colors.white,size: h*0.03,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}