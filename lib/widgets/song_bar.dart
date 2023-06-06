import 'package:flutter/cupertino.dart';

import '../utils/tiktok_colors.dart';
import '../utils/tiktok_images.dart';

Widget buildSongBarWidget(String playlist) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      color: TikTokColors.playlistBackgroundColor,
      height: 36,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 4.0),
            child: TikTokImages.play,
          ),
          Text(
            playlist,
            style: const TextStyle(
              color: TikTokColors.selectedText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: TikTokImages.arrow,
          ),
        ],
      ),
    ),
  );
}