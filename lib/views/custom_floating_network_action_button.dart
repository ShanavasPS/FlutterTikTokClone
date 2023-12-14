import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../utils/tiktok_strings.dart';

class CustomFloatingNetworkImageActionButton extends StatelessWidget {
  const CustomFloatingNetworkImageActionButton({super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> avatarAndPlaylist = context.watch<DataProvider>().updateAvatarAndPlaylist();
    final bool showFollow = context.watch<DataProvider>().tabIndex == 1;

    return FloatingActionButton(
      onPressed: () {
        // Handle button press
      },
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: SizedBox(
        width: 45,
        height: 55,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.network(
                avatarAndPlaylist[0],
                width: 45,
                height: 45,
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
                    TikTokStrings.ellipsesImagePath,
                    height: 45,
                    width: 45,
                  );
                },
              ),
            ),
            Visibility(
              visible: showFollow,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  TikTokStrings.followImagePath,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}