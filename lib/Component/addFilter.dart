import 'package:flutter/material.dart';
import 'package:video_editor_git/Constant/List/fontFamilyList.dart';

class AddFilterWidget extends StatefulWidget {
  const AddFilterWidget({Key? key}) : super(key: key);

  @override
  _AddFilterWidgetState createState() => _AddFilterWidgetState();
}

class _AddFilterWidgetState extends State<AddFilterWidget> {

  int? filterId;
  List<Color>? filterLinearGradient = [Colors.transparent,Colors.transparent];

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
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
}
