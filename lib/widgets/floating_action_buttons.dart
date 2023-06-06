import 'package:flutter/material.dart';
import 'package:tiktokclone/utils/tiktok_strings.dart';
import 'package:tiktokclone/widgets/custom_floating_action_button.dart';
import 'package:tiktokclone/widgets/custom_floating_network_action_button.dart';

Widget buildFloatingActionButtons(String avatar) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 36.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildCustomFloatingNetworkActionButton(avatar, TikTokStrings.ellipsesImagePath, 55, 55, ""),
        const SizedBox(height: 16),
        buildCustomFloatingActionButton(TikTokStrings.likeImagePath, 32, 30, TikTokStrings.likeCount),
        const SizedBox(height: 16),
        buildCustomFloatingActionButton(TikTokStrings.commentsImagePath, 32, 30, TikTokStrings.commentsCount),
        const SizedBox(height: 16),
        buildCustomFloatingActionButton(TikTokStrings.shareImagePath, 32, 30, TikTokStrings.shareCount),
        const SizedBox(height: 16),
        buildCustomFloatingActionButton(TikTokStrings.bookmarkImagePath, 32, 30, TikTokStrings.bookmarkCount),
        const SizedBox(height: 16),
        buildCustomFloatingActionButton(TikTokStrings.refreshImagePath, 32, 30, TikTokStrings.flip),
      ],
    ),
  );
}