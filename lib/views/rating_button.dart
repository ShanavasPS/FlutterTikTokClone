import 'package:flutter/cupertino.dart';

import '../utils/tiktok_colors.dart';

Widget ratingButton(BuildContext context, String label, Color color, final Function() onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
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
      ),
    ),
  );
}
