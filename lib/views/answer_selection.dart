import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/utils/tiktok_colors.dart';
import 'package:tiktokclone/utils/tiktok_images.dart';
import 'package:tiktokclone/utils/tiktok_strings.dart';

class AnswerSelectionView extends StatefulWidget {
  final Map<String, dynamic> content;
  final Map<String, dynamic> answer;
  const AnswerSelectionView({super.key, required this.content, required this.answer});

  @override
  AnswerSelectionViewState createState() => AnswerSelectionViewState();
}

class AnswerSelectionViewState extends State<AnswerSelectionView> {
  AnswerSelectionViewState() : super();

  @override
  void initState() {
    super.initState();
    print('inside state:');
  }

  Color answerAColor = TikTokColors.defaultAnswerColor;
  Color answerBColor = TikTokColors.defaultAnswerColor;
  Color answerCColor = TikTokColors.defaultAnswerColor;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> content = widget.content;
    final Map<String, dynamic> answer = widget.answer;

    // Access the 'options' array
    final List<dynamic> options = content['options'];
    // Find the option with id 'A'
    final Map<String, dynamic> optionA = options.firstWhere((
        option) => option['id'] == 'A');
    // Read the answer from the optionA
    final String answerA = optionA['answer'];
    // Find the option with id 'B'
    final Map<String, dynamic> optionB = options.firstWhere((
        option) => option['id'] == 'B');
    // Read the answer from the optionB
    final String answerB = optionB['answer'];
    // Find the option with id 'C'
    final Map<String, dynamic> optionC = options.firstWhere((
        option) => option['id'] == 'C');
    // Read the answer from the optionC
    final String answerC = optionC['answer'];

    // Extract the 'correct_options' array
    List<dynamic> correctOptions = answer['correct_options'];

    // Extract the first item from 'correct_options' array
    Map<String, dynamic> firstOption = correctOptions[0];

    // Extract the 'id' value from the first option
    String correctAnswer = firstOption['id'];

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print("answer a tapped");
            setState(() {
              print("inside set state");
              print("correct answer is $correctAnswer");
              print("correct answer is ${TikTokStrings.answerA}");
              // Change the color when pressed
              // Set the new color value based on your requirement
              if(correctAnswer == TikTokStrings.answerA) {
                print("inside first condition");
                answerAColor = TikTokColors.correctAnswerColor;
              } else {
                if(correctAnswer == TikTokStrings.answerB) {
                  answerBColor = TikTokColors.correctAnswerColor;
                } else {
                  answerCColor = TikTokColors.correctAnswerColor;
                }
                answerAColor = TikTokColors.incorrectAnswerColor;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: answerAColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  12, 16, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      answerA,
                      style: const TextStyle(
                        color: TikTokColors.selectedText,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: answerAColor == TikTokColors.correctAnswerColor,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: TikTokImages.tick,
                    ),
                  ),
                  Visibility(
                    visible: answerAColor == TikTokColors.incorrectAnswerColor,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: TikTokImages.cross,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            print("answer b tapped");
            setState(() {
              print("inside set state");
              // Change the color when pressed
              // Set the new color value based on your requirement
              if(correctAnswer == TikTokStrings.answerB) {
                answerBColor = TikTokColors.correctAnswerColor;
              } else {
                if(correctAnswer == TikTokStrings.answerA) {
                  answerAColor = TikTokColors.correctAnswerColor;
                } else {
                  answerCColor = TikTokColors.correctAnswerColor;
                }
                answerBColor = TikTokColors.incorrectAnswerColor;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: answerBColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  12, 16, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      answerB,
                      style: const TextStyle(
                        color: TikTokColors.selectedText,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: answerBColor == TikTokColors.correctAnswerColor,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: TikTokImages.tick,
                    ),
                  ),
                  Visibility(
                    visible: answerBColor == TikTokColors.incorrectAnswerColor,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: TikTokImages.cross,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            print("answer c tapped");
            setState(() {
              print("inside set state");
              if(correctAnswer == TikTokStrings.answerC) {
                answerCColor = TikTokColors.correctAnswerColor;
              } else {
                if(correctAnswer == TikTokStrings.answerA) {
                  answerAColor = TikTokColors.correctAnswerColor;
                } else {
                  answerBColor = TikTokColors.correctAnswerColor;
                }
                answerCColor = TikTokColors.incorrectAnswerColor;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: answerCColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  12, 16, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      answerC,
                      style: const TextStyle(
                        color: TikTokColors.selectedText,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: answerCColor == TikTokColors.correctAnswerColor,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: TikTokImages.tick,
                    ),
                  ),
                  Visibility(
                    visible: answerCColor == TikTokColors.incorrectAnswerColor,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: TikTokImages.cross,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}