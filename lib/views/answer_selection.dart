import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/model/answer_model.dart';
import 'package:tiktokclone/model/mcq_data.dart';

import '../utils/tiktok_strings.dart';
import '../widgets/answer_options.dart';

class AnswerSelectionView extends StatefulWidget {
  final McqData content;
  final AnswerData answer;
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
    final McqData content = widget.content;
    final AnswerData answer = widget.answer;

    String optionA = content.options[0].answer;
    String optionB = content.options[1].answer;
    String optionC = content.options[2].answer;

    String correctAnswer = answer.correctOptions[0].id;


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
          child: answerOptions(TikTokStrings.optionA, optionA, correctAnswer, didTapOptionA, didTapOptionA || didTapOptionB || didTapOptionC),
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
          child: answerOptions(TikTokStrings.optionB, optionB, correctAnswer, didTapOptionB, didTapOptionA || didTapOptionB || didTapOptionC),
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
          child: answerOptions(TikTokStrings.optionC, optionC, correctAnswer, didTapOptionC, didTapOptionA || didTapOptionB || didTapOptionC),
        ),
      ],
    );
  }
}