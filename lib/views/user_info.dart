import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../model/flashcard_data.dart';
import '../model/mcq_data.dart';
import '../providers/data_provider.dart';
import '../utils/tiktok_colors.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    String username = "";
    String description = "";
    if(context.watch<DataProvider>().tabIndex == 0) {
      final FlashcardData content = context.watch<DataProvider>().getFlashCardContent();
      username = content.user.name;
      description = content.description;
    } else {
      final McqData content =  context.read<DataProvider>().getMCQContent();
      username = content.user.name;
      description = content.description;
    }

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
}