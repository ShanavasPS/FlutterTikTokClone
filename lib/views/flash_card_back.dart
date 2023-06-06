import 'package:flutter/cupertino.dart';

import '../views/rating_view.dart';
import '../utils/tiktok_colors.dart';
import '../utils/tiktok_strings.dart';

class FlashCardBack extends StatefulWidget {
  final String flashcardBackText;
  final bool showBackOfFlashCard;
  final Function(bool) updateFlashCardFeedState;
  const FlashCardBack({super.key, required this.flashcardBackText, required this.showBackOfFlashCard, required this.updateFlashCardFeedState});

  @override
  FlashCardBackState createState() => FlashCardBackState();
}

class FlashCardBackState extends State<FlashCardBack> {
  FlashCardBackState() : super();

  bool showBack = false;

  @override
  void initState() {
    super.initState();
    print("Inside initState");
    print('inside FlashCardBackState: $showBack');
  }

  @override
  void didUpdateWidget(covariant FlashCardBack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBackOfFlashCard != oldWidget.showBackOfFlashCard) {
      setState(() {
        showBack = widget.showBackOfFlashCard;
      });
    }
  }

  void updateFlashCardBackState(bool showBackOfFlashCard) {
    // Update the state value in the parent widget
    setState(() {
      print("Inside FlashCardBackState $showBackOfFlashCard");
      // Update the state value with the new value received from the child
      showBack = showBackOfFlashCard;
      widget.updateFlashCardFeedState(showBackOfFlashCard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showBack,
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
                  widget.flashcardBackText,
                  style: TextStyle(
                    color: TikTokColors.descriptionTextColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          RatingView(showBackOfFlashCard: showBack, updateFlashCardBackState: updateFlashCardBackState),
        ],
      ),
    );
  }
}