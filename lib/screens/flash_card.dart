import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktokclone/model/flashcard_data.dart';

import '../providers/data_provider.dart';
import '../utils/tiktok_colors.dart';
import '../views/flash_card_back.dart';
import '../views/user_info.dart';

class FlashCardFeed extends StatelessWidget {
  const FlashCardFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final index = context.watch<DataProvider>().followingPageItemIndex;
    final FlashcardData content = context.read<DataProvider>().followingItems[index];

    final String flashcardFrontText = content.flashcardFront;
    final String username = content.user.name;
    final String description = content.description;

    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: GestureDetector(
        onTap: () {
          context.read<DataProvider>().toggleFlashCardView();
        },
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 73.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      flashcardFrontText,
                      style: const TextStyle(
                        color: TikTokColors.selectedText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const FlashCardBack(),
                buildUserInfo(username, description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}