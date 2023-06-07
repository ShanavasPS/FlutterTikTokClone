import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/tiktok_colors.dart';
import '../utils/tiktok_strings.dart';
import '../widgets/rating_button.dart';

class RatingView extends StatefulWidget {
  final bool showBackOfFlashCard;
  final Function(bool) updateFlashCardBackState;
  const RatingView({super.key, required this.showBackOfFlashCard, required this.updateFlashCardBackState});

  @override
  RatingViewState createState() => RatingViewState();
}

class RatingViewState extends State<RatingView> {
  RatingViewState() : super();

  @override
  void initState() {
    super.initState();
    print('inside state:');
  }

  bool isColoredBoxSelected = false;

  bool didTapOnButtonOne = false;
  bool didTapOnButtonTwo = false;
  bool didTapOnButtonThree = false;
  bool didTapOnButtonFour = false;
  bool didTapOnButtonFive = false;

  @override
  Widget build(BuildContext context) {

    bool didTapOnAnyButton = didTapOnButtonOne || didTapOnButtonTwo || didTapOnButtonThree || didTapOnButtonFour || didTapOnButtonFive;

    bool showButtonOne = !didTapOnAnyButton || didTapOnButtonOne;
    bool showButtonTwo = !didTapOnAnyButton || didTapOnButtonTwo;
    bool showButtonThree = !didTapOnAnyButton || didTapOnButtonThree;
    bool showButtonFour = !didTapOnAnyButton || didTapOnButtonFour;
    bool showButtonFive = !didTapOnAnyButton || didTapOnButtonFive;

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
            Visibility(
              visible: showButtonOne,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!didTapOnAnyButton) {
                        didTapOnButtonOne = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: ratingButton(context, TikTokStrings.ratingOne, TikTokColors.princetonOrange),
                ),
              ),
            ),
            Visibility(
                visible: showButtonOne,
                child: const SizedBox(width: 8)
            ),
            Visibility(
              visible:showButtonTwo,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!didTapOnAnyButton) {
                        didTapOnButtonTwo = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: ratingButton(context, TikTokStrings.ratingTwo, TikTokColors.mellowApricot),
                ),
              ),
            ),
            Visibility(
                visible: showButtonTwo,
                child: const SizedBox(width: 8)
            ),
            Visibility(
              visible: showButtonThree,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!didTapOnAnyButton) {
                        didTapOnButtonThree = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: ratingButton(context, TikTokStrings.ratingThree, TikTokColors.mustard),
                ),
              ),
            ),
            Visibility(
                visible: showButtonThree,
                child: const SizedBox(width: 8)
            ),
            Visibility(
              visible: showButtonFour,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!didTapOnAnyButton) {
                        didTapOnButtonFour = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: ratingButton(context, TikTokStrings.ratingFour, TikTokColors.darkGreenColor),
                ),
              ),
            ),
            Visibility(
                visible: showButtonFour,
                child: const SizedBox(width: 8)
            ),
            Visibility(
              visible: showButtonFive,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!didTapOnAnyButton) {
                        didTapOnButtonFive = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: ratingButton(context, TikTokStrings.ratingFive, TikTokColors.illuminatingEmerald),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}