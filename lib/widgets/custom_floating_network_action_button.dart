import 'package:flutter/material.dart';

Widget buildCustomFloatingNetworkImageActionButton(String imageName, String errorImage, String secondaryImage, double height, double width) {
  return FloatingActionButton(
    onPressed: () {
      // Handle button press
    },
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    child: SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.network(
              imageName,
              width: 45,
              height: 45,
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
                  height: 45,
                  width: 45,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              secondaryImage,
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    ),
  );
}