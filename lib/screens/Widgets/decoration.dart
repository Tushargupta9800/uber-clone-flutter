import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget space(double height){
  return SizedBox(height: height,);
}

BoxDecoration box_decoration(){
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6.0,
              spreadRadius: 0.5,
              offset: Offset(0.7,0.7),
            ),
        ],
  );
}

BoxDecoration round_corners(double radius, var color){
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Widget side_space(double width){
  return SizedBox(width: width,);
}

BoxDecoration round_decoration(double round){
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(round)),
    boxShadow: [
      BoxShadow(
        color: Colors.black54,
        blurRadius: 6.0,
        spreadRadius: 1,
        offset: Offset(0.7,0.7),
      ),
    ],
    color: Colors.blue,
  );
}

Widget divider(double height,double thickness){
  return Container(
    padding: EdgeInsets.only(right: 20.0),
    child: Divider(
      height: height,
      thickness: thickness,
    ),
  );
}