import 'package:flutter/cupertino.dart';

import '../utils/tiktok_colors.dart';

Widget gradientBackground() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          TikTokColors.backgroundGradientBegin,
          TikTokColors.backgroundGradientEnd,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
      ),
    ),
  );
}