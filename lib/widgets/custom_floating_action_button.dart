import 'package:flutter/material.dart';
import 'package:tiktokclone/utils/tiktok_colors.dart';

Widget buildCustomFloatingActionButton(String imageName, double height, double width, String text) {
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
        Expanded(
            child: Image.asset(
              imageName,
              height: height,
              width: width,
            ),
        ),
        Visibility(
          visible: showLabel,
          child: Text(
              text,
              style: const TextStyle(color: TikTokColors.selectedText),
          ),
        ),
      ],
    ),
  );
}