import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tittokclone/widgets/flash_card_back.dart';
import 'package:tittokclone/utils/common.dart';

class FlashCardFeed extends StatefulWidget {
  final Map<String, dynamic> content;
  FlashCardFeed({required this.content});

  @override
  FlashCardFeedState createState() => FlashCardFeedState();
}

class FlashCardFeedState extends State<FlashCardFeed> {
  FlashCardFeedState() : super();

  bool showBackOfFlashCard = false;

  @override
  void initState() {
    super.initState();
    print('inside state:');
  }

  void updateFlashCardFeedState(bool showBackOfFlashCard) {
    // Update the state value in the parent widget
    setState(() {
      print("Inside Flash Card Feed State $showBackOfFlashCard");
      // Update the state value with the new value received from the child
      this.showBackOfFlashCard = showBackOfFlashCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> content = widget.content;

    String flashcardFrontText = content["flashcard_front"];
    String flashcardBackText = content["flashcard_back"];

    final String username = content['user']['name'];
    final String description = content['description'];

    return Container(
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
          print("container tapped");
          print(showBackOfFlashCard);
          setState(() {
            print("inside set state");
            showBackOfFlashCard = !showBackOfFlashCard;
          });
        },
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 73.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        flashcardFrontText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  FlashCardBack(flashcardBackText: flashcardBackText, showBackOfFlashCard: showBackOfFlashCard, updateFlashCardFeedState: updateFlashCardFeedState),
                  buildUserInfo(username, description),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}