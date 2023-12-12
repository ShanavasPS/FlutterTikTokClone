import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'top_bar_button.dart';
import '../providers/data_provider.dart';
import '../providers/duration_provider.dart';
import '../utils/common.dart';
import '../utils/tiktok_colors.dart';
import '../utils/tiktok_images.dart';
import '../utils/tiktok_strings.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final int tabIndex = context.watch<DataProvider>().tabIndex;
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
                        context.watch<DurationProvider>().actualTimeSpent,
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
                        TopBarButton(
                            title: TikTokStrings.following,
                            buttonStyle: followingTextStyle
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        TopBarButton(
                            title: TikTokStrings.forYou,
                            buttonStyle: forYouTextStyle
                        ),
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
}