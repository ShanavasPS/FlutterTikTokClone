import 'package:flutter/material.dart';

import '../utils/tiktok_colors.dart';

Widget buildLoaderIndicator(bool isLoading) {
  return isLoading ? Center(
    child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: TikTokColors.progressIndicatorColor,
        )
    ),
  ) : const SizedBox.shrink();
}