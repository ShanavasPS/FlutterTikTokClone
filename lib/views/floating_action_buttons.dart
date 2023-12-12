import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../utils/tiktok_strings.dart';
import '../views/custom_floating_action_button.dart';
import '../views/custom_floating_network_action_button.dart';

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> avatarAndPlaylist = context.watch<DataProvider>().updateAvatarAndPlaylist();
    return Padding(
      padding: const EdgeInsets.only(bottom: 36.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildCustomFloatingNetworkImageActionButton(
              avatarAndPlaylist[0], TikTokStrings.ellipsesImagePath,
              TikTokStrings.followImagePath, 55, 45, context.read<DataProvider>().tabIndex == 1),
          const SizedBox(height: 4),
          buildCustomFloatingActionButton(
              TikTokStrings.likeImagePath, 26, 28, TikTokStrings.likeCount),
          buildCustomFloatingActionButton(
              TikTokStrings.commentsImagePath, 26, 27,
              TikTokStrings.commentsCount),
          buildCustomFloatingActionButton(
              TikTokStrings.shareImagePath, 28, 27, TikTokStrings.shareCount),
          buildCustomFloatingActionButton(
              TikTokStrings.bookmarkImagePath, 24, 22,
              TikTokStrings.bookmarkCount),
          buildCustomFloatingActionButton(
              TikTokStrings.refreshImagePath, 38, 38, TikTokStrings.flip),
        ],
      ),
    );
  }
}