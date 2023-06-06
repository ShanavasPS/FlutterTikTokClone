import 'package:flutter/cupertino.dart';

import '../utils/tiktok_colors.dart';
import '../utils/tiktok_images.dart';

Widget answerOptions(String option, String optionText, String answer, bool didTapThisOption, bool didTapAnOption) {
  print("didTap value $option $answer $didTapAnOption");
  print(didTapAnOption ? (option == answer ? TikTokColors.correctAnswerColor : TikTokColors.incorrectAnswerColor) : TikTokColors.defaultAnswerColor);
  Color backgroundColor = TikTokColors.defaultAnswerColor;
  bool isCorrect = false;
  bool isIncorrect = false;
  if(didTapAnOption) {
    if(option == answer) {
      isCorrect = true;
      backgroundColor = TikTokColors.correctAnswerColor;
    } else if(didTapThisOption) {
      isIncorrect = true;
      backgroundColor = TikTokColors.incorrectAnswerColor;
    }
  }

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: backgroundColor,
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
          12, 16, 12, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              optionText,
              style: const TextStyle(
                color: TikTokColors.selectedText,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Visibility(
            visible: isCorrect,
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: TikTokImages.tick,
            ),
          ),
          Visibility(
            visible: isIncorrect,
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: TikTokImages.cross,
            ),
          ),
        ],
      ),
    ),
  );
}