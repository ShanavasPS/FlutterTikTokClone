import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/tiktok_strings.dart';
import '../widgets/answer_options.dart';

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

  bool didTapOptionA = false;
  bool didTapOptionB = false;
  bool didTapOptionC = false;

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
              didTapOptionA = true;
              print("inside set state");
              print("correct answer is $correctAnswer");
            });
          },
          child: answerOptions(TikTokStrings.optionA, answerA, correctAnswer, didTapOptionA, didTapOptionA || didTapOptionB || didTapOptionC),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            print("answer b tapped");
            setState(() {
              print("inside set state");
              didTapOptionB = true;
            });
          },
          child: answerOptions(TikTokStrings.optionB, answerB, correctAnswer, didTapOptionB, didTapOptionA || didTapOptionB || didTapOptionC),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            print("answer c tapped");
            setState(() {
              print("inside set state");
              didTapOptionC = true;
            });
          },
          child: answerOptions(TikTokStrings.optionC, answerC, correctAnswer, didTapOptionC, didTapOptionA || didTapOptionB || didTapOptionC),
        ),
      ],
    );
  }
}