import 'package:flutter/cupertino.dart';

Widget topBarButton(final Function() onTap, String title, TextStyle buttonStyle) {
  return GestureDetector(
    onTap: onTap,
    child: Text(title,
        style: buttonStyle),
  );
}