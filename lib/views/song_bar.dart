import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../utils/tiktok_colors.dart';
import '../utils/tiktok_images.dart';

class SongBar extends StatelessWidget {
  const SongBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> avatarAndPlaylist = context.watch<DataProvider>().updateAvatarAndPlaylist();
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: TikTokColors.playlistBackgroundColor,
        height: 36,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 4.0),
              child: TikTokImages.play,
            ),
            Text(
              avatarAndPlaylist[1],
              style: const TextStyle(
                color: TikTokColors.selectedText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: TikTokImages.arrow,
            ),
          ],
        ),
      ),
    );
  }
}