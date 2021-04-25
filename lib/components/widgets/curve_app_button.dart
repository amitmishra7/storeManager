import 'package:firestore_demo/components/util/app_constants.dart';
import 'package:firestore_demo/components/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

class CurveButton extends StatelessWidget {
  double width;
  double height=55;

  String text;

  CurveButton({this.width,  this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: AppConstants.butt_blue,
      ),
      child: Center(
        child: TextWidgets(text:text,fontSize:16,color: Colors.white,fontFamily: "sfpro",),
      ),
    );
  }
}