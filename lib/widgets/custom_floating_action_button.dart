import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCustomFloatingActionButton(String imageName, double height, double weight, String text) {
  bool showLabel = true;
  if(text.isEmpty) {
    showLabel = false;
  }
  return FloatingActionButton(
    onPressed: () {
      // Handle button press
    },
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imageName,
          height: height,
          width: weight,
        ),
        Visibility(
          visible: showLabel,
          child: Text(
              text
          ),
        ),
      ],
    ),
  );
}