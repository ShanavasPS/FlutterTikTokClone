import 'package:flutter/cupertino.dart';
import 'package:tiktokclone/model/answer_model.dart';

import '../utils/tiktok_colors.dart';
import '../utils/tiktok_images.dart';

Widget answerOptions({
  required String optionId,
  required String optionText,
  required AnswerData answer,
  required bool didTapThisOption,
  required bool didTapAnOption,
  required VoidCallback onTap,
}) {
  Color backgroundColor = TikTokColors.defaultAnswerColor;
  bool isCorrect = false;
  bool isIncorrect = false;
  if(didTapAnOption) {
    if(answer.correctOptions.any((option) => option.id == optionId)) {
      isCorrect = true;
      backgroundColor = TikTokColors.correctAnswerColor;
    } else if(didTapThisOption) {
      isIncorrect = true;
      backgroundColor = TikTokColors.incorrectAnswerColor;
    }
  }

  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
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
    ),
  );
}
