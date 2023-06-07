import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../utils/tiktok_colors.dart';

Widget ratingButton(BuildContext context, String label, Color color) {
  print("inside ratingButton $label");
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: color,
    ),
    width: (MediaQuery.of(context).size.width - 8 * 6) / 5,
    height: 52,
    child: Center(
      child: Text(
        label,
        style: const TextStyle(
          color: TikTokColors.selectedText,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}