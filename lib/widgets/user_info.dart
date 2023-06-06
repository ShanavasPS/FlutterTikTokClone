import 'package:flutter/cupertino.dart';
import 'package:tiktokclone/utils/tiktok_colors.dart';

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