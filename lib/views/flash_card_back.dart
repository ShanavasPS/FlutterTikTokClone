import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../model/flashcard_data.dart';
import '../views/rating_view.dart';
import '../utils/tiktok_colors.dart';
import '../utils/tiktok_strings.dart';

class FlashCardBack extends StatelessWidget {
  const FlashCardBack({super.key});

  @override
  Widget build(BuildContext context) {
    final FlashcardData content = context.watch<DataProvider>().getFlashCardContent();
    String flashcardBackText = content.flashcardBack;

    return Visibility(
      visible: context.watch<DataProvider>().showFlashCardBackView,
      child: Column(
        children: [
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: TikTokColors.defaultAnswerColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                TikTokStrings.answer,
                style: TextStyle(
                  color: TikTokColors.answerTitleColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.2,
                ),
                child: Text(
                  flashcardBackText,
                  style: TextStyle(
                    color: TikTokColors.descriptionTextColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          const RatingView(),
        ],
      ),
    );
  }
}