

import 'package:flutter/material.dart';
import 'package:video_editor_git/Constant/const.dart';
import 'package:video_editor_git/Constant/List/fontFamilyList.dart';

class FontFamilyViewWidget extends StatefulWidget {
  // FontFamilyViewWidget({Key? key}) : super(key: key);

  @override
  _FontFamilyViewWidgetState createState() => _FontFamilyViewWidgetState();
}

class _FontFamilyViewWidgetState extends State<FontFamilyViewWidget> {

  int? textId,textFamilyId;
  Shader? linearGradient;
  String setFontFamily = '';

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return
      // seeFontFamilyView == false  ? SizedBox() :
      Expanded(
         child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          height: h*0.4,
          decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 1.0)]),
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
                          setFontFamily = FamilyList().fontFamilyData[index].toString().replaceAll('fonts/', '').replaceAll('.ttf', '');
                          // MovableStackTextItem().fontFamily = setFontFamily;
                          // movableTextItems.add(MovableStackTextItem(
                          //   text: addText,
                          //   fontColor: linearGradient,
                          //   fontFamily: setFontFamily,));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: textFamilyId == index ? Colors.blue : Colors.transparent, width: 2)),
                        alignment: Alignment.center,
                        child: Text(
                          'Font Family ${index+1}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: FamilyList().fontFamilyData[index].toString().replaceAll('fonts/', '').replaceAll('.ttf', '')))),
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
                            linearGradient = LinearGradient(
                              begin: FractionalOffset.centerLeft,
                              end: FractionalOffset.centerRight,
                              tileMode: TileMode.mirror,
                              stops: [0.0, 1.0],
                              colors: FamilyList().colorList[index]!,//<Color>[Colors.red, Colors.blue],
                            ).createShader(Rect.fromCircle(center: Offset(200, 0), radius: 150));
                            //createShader(Rect.fromLTWH(0.0, 20.0, 50.0, 20.0));
                            // MovableStackTextItem().fontColor = linearGradient;
                            // movableTextItems.add(MovableStackTextItem(
                            //   text: addText,
                            //   fontColor: linearGradient,
                            //   fontFamily: setFontFamily
                            // ));
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
                              )),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
