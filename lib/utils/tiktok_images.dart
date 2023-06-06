import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:tittokclone/utils/tiktok_strings.dart';

class TikTokImages {
  TikTokImages._();

  static const Image time = Image(image: AssetImage(TikTokStrings.timeImagePath));
  static const Image search = Image(image: AssetImage(TikTokStrings.searchImagePath));
  static const Image play = Image(image: AssetImage(TikTokStrings.playImagePath));
  static const Image arrow = Image(image: AssetImage(TikTokStrings.arrowImagePath));
  static const Image home = Image(image: AssetImage(TikTokStrings.homeImagePath));
  static const Image discover = Image(image: AssetImage(TikTokStrings.discoverImagePath));
  static const Image activity = Image(image: AssetImage(TikTokStrings.activityImagePath));
  static const Image bookmarks = Image(image: AssetImage(TikTokStrings.bookmarksImagePath));
  static const Image profile = Image(image: AssetImage(TikTokStrings.profileImagePath));
  static const Image tick = Image(image: AssetImage(TikTokStrings.tickImagePath));
  static const Image cross = Image(image: AssetImage(TikTokStrings.crossImagePath));
}