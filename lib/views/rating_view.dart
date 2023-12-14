import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../utils/tiktok_colors.dart';
import '../utils/tiktok_strings.dart';
import 'rating_button.dart';

class RatingView extends StatelessWidget {
  const RatingView({super.key});

  void handleRatingButtonTap(BuildContext context, int index) {
    if (!context.read<DataProvider>().getRatings().any((tapped) => tapped)) {
      context.read<DataProvider>().updateRatingSelection(index, true);
    } else {
      context.read<DataProvider>().toggleFlashCardView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<bool> ratings = context.watch<DataProvider>().getRatings();
    bool didTapOnAnyButton = ratings.any((tapped) => tapped);

    List<Color> ratingColors = [
      TikTokColors.princetonOrange,
      TikTokColors.mellowApricot,
      TikTokColors.mustard,
      TikTokColors.darkGreenColor,
      TikTokColors.illuminatingEmerald,
    ];

    List<String> ratingStrings = [
      TikTokStrings.ratingOne,
      TikTokStrings.ratingTwo,
      TikTokStrings.ratingThree,
      TikTokStrings.ratingFour,
      TikTokStrings.ratingFive,
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 5),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              TikTokStrings.howWellDidYouKnowThis,
              style: TextStyle(
                color: TikTokColors.descriptionTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < ratings.length; i++) ...[
              if (!didTapOnAnyButton || ratings[i]) ...[
                ratingButton(
                  context,
                  ratingStrings[i],
                  ratingColors[i],
                      () => handleRatingButtonTap(context, i),
                ),
                if (i < ratings.length - 1) const SizedBox(width: 8),
              ],
            ],
          ],
        ),
      ],
    );
  }
}
