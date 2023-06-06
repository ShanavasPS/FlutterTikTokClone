import 'package:flutter/cupertino.dart';
import 'package:tiktokclone/widgets/top_bar_button.dart';

import '../utils/common.dart';
import '../utils/tiktok_colors.dart';
import '../utils/tiktok_images.dart';
import '../utils/tiktok_strings.dart';

Widget buildTopBar(int tabIndex, String actualTimeSpent, final Function() followingTapped, final Function() forYouTapped) {

  final followingTextStyle = TextStyle(
      fontSize: 17.0,
      fontWeight: tabIndex == 0 ? FontWeight.bold: FontWeight.normal,
      color: tabIndex == 0 ? TikTokColors.selectedText: TikTokColors.unselectedText);

  final forYouTextStyle = TextStyle(
      fontSize: 17.0,
      fontWeight: tabIndex == 1 ? FontWeight.bold: FontWeight.normal,
      color: tabIndex == 1 ? TikTokColors.selectedText: TikTokColors.unselectedText);

  return SafeArea(
    child: Stack(
        children: [
          Container(
            height: 54,
            color: TikTokColors.statusBar,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 4),
                  child: TikTokImages.time,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                      actualTimeSpent,
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: TikTokColors.unselectedText)
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      topBarButton(followingTapped, TikTokStrings.following, followingTextStyle),
                      const SizedBox(
                        width: 18,
                      ),
                      topBarButton(forYouTapped, TikTokStrings.forYou, forYouTextStyle),
                    ]
                ),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: 5, left: tabIndex == 1? measureTextWidth(TikTokStrings.forYou, forYouTextStyle) + 18 + 15: 0, right: tabIndex == 0 ? measureTextWidth(TikTokStrings.following, followingTextStyle)/2 + 15 + 18 : 0),
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 30,
                    height: 4,
                    color: TikTokColors.selectedText,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, right: 16),
            child: Align(
              alignment: Alignment.topRight,
              child: TikTokImages.search,
            ),
          ),
        ]
    ),
  );
}