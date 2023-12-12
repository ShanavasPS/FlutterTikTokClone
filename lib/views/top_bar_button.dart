import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../utils/tiktok_strings.dart';

class TopBarButton extends StatelessWidget {
  final String title;
  final TextStyle buttonStyle;

  const TopBarButton({super.key, required this.title, required this.buttonStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if(title == TikTokStrings.following) {
          context.read<DataProvider>().updateTabIndex(0)
        } else {
          context.read<DataProvider>().updateTabIndex(1)
        }
      },
      child: Text(
        title,
        style: buttonStyle,
      ),
    );
  }
}