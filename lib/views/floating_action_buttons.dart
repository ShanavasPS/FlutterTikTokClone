import 'package:flutter/material.dart';

import '../utils/tiktok_strings.dart';
import '../widgets/custom_floating_action_button.dart';
import '../widgets/custom_floating_network_action_button.dart';

Widget buildFloatingActionButtons(String avatar, int tabIndex) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 36.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildCustomFloatingNetworkImageActionButton(avatar, TikTokStrings.ellipsesImagePath, TikTokStrings.followImagePath, 55, 45, tabIndex == 1),
        const SizedBox(height: 4),
        buildCustomFloatingActionButton(TikTokStrings.likeImagePath, 26, 28, TikTokStrings.likeCount),
        buildCustomFloatingActionButton(TikTokStrings.commentsImagePath, 26, 27, TikTokStrings.commentsCount),
        buildCustomFloatingActionButton(TikTokStrings.shareImagePath, 28, 27, TikTokStrings.shareCount),
        buildCustomFloatingActionButton(TikTokStrings.bookmarkImagePath, 24, 22, TikTokStrings.bookmarkCount),
        buildCustomFloatingActionButton(TikTokStrings.refreshImagePath, 38, 38, TikTokStrings.flip),
      ],
    ),
  );
}