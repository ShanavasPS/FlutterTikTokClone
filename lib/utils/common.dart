import 'package:flutter/material.dart';
import 'package:tiktokclone/utils/tiktok_colors.dart';
import 'package:tiktokclone/utils/tiktok_strings.dart';
import 'package:tiktokclone/utils/tiktok_images.dart';

Widget buildCustomFloatingActionButton(String imageName, double height, double weight, String text) {
  bool showLabel = true;
  if(text.isEmpty) {
    showLabel = false;
  }
  return FloatingActionButton(
    onPressed: () {
      // Handle button press
    },
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imageName,
          height: height,
          width: weight,
        ),
        Visibility(
          visible: showLabel,
          child: Text(
              text
          ),
        ),
      ],
    ),
  );
}

Widget buildCustomFloatingNetworkActionButton(String imageName, String errorImage, double height, double weight, String text) {
  bool showLabel = true;
  if(text.isEmpty) {
    showLabel = false;
  }
  return FloatingActionButton(
    onPressed: () {
      // Handle button press
    },
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          imageName,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              errorImage,
              height: height,
              width: weight,
            );
          },
        ),
        Visibility(
          visible: showLabel,
          child: Text(
              text
          ),
        ),
      ],
    ),
  );
}

Widget buildFloatingActionButton(String avatar) {
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

Widget buildBottomNavigationBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).copyWith(
      canvasColor: TikTokColors.statusBar, // Set the background color to black
    ),
    child: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.home
          ),
          label: TikTokStrings.bottomBarHome,
        ),
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.discover
          ),
          label: TikTokStrings.bottomBarDiscover,
        ),
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.activity
          ),
          label: TikTokStrings.bottomBarActivity,
        ),
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.bookmarks
          ),
          label: TikTokStrings.bottomBarBookmarks,
        ),
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: TikTokImages.profile
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

Widget buildUserInfo(String username, String description) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  username,
                  style: const TextStyle(
                    color: TikTokColors.selectedText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: TikTokColors.selectedText,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}