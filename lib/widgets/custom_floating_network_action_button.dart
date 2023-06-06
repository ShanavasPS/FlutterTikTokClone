import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCustomFloatingNetworkActionButton(String imageName, String errorImage, double height, double weight, String text) {
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
        Image.network(
          imageName,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              errorImage,
              height: height,
              width: weight,
            );
          },
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