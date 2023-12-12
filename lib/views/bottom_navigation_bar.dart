import 'package:flutter/material.dart';

import '../utils/tiktok_colors.dart';
import '../utils/tiktok_images.dart';
import '../utils/tiktok_strings.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: TikTokColors.statusBar, // Set the background color to black
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.home,
            ),
            label: TikTokStrings.bottomBarHome,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.discover,
            ),
            label: TikTokStrings.bottomBarDiscover,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.activity,
            ),
            label: TikTokStrings.bottomBarActivity,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.bookmarks,
            ),
            label: TikTokStrings.bottomBarBookmarks,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.profile,
            ),
            label: TikTokStrings.bottomBarProfile,
          ),
        ],
        selectedItemColor: TikTokColors.selectedText,
        unselectedItemColor: TikTokColors.unselectedBottomBarText,
        showUnselectedLabels: true,
      ),
    );
  }
}