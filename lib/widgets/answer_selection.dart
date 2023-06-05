import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswerSelectionView extends StatefulWidget {
  final Map<String, dynamic> content;
  final Map<String, dynamic> answer;
  AnswerSelectionView({required this.content, required this.answer});

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

  Color correctAnswerColor = Color(0xFF28B18F);
  Color incorrectAnswerColor = Color(0xFFDC5F5F);
  Color answerAColor = Color(0xFFFFFFFF).withOpacity(0.2);
  Color answerBColor = Color(0xFFFFFFFF).withOpacity(0.2);
  Color answerCColor = Color(0xFFFFFFFF).withOpacity(0.2);

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
              // Change the color when pressed
              // Set the new color value based on your requirement
              if(correctAnswer == "A") {
                answerAColor = correctAnswerColor;
              } else {
                if(correctAnswer == "B") {
                  answerBColor = correctAnswerColor;
                } else {
                  answerCColor = correctAnswerColor;
                }
                answerAColor = incorrectAnswerColor;
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
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: answerAColor == correctAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/TickMark.png"),
                    ),
                  ),
                  Visibility(
                    visible: answerAColor == incorrectAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/Cross.png"),
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
              if(correctAnswer == "B") {
                answerBColor = correctAnswerColor;
              } else {
                if(correctAnswer == "A") {
                  answerAColor = correctAnswerColor;
                } else {
                  answerCColor = correctAnswerColor;
                }
                answerBColor = incorrectAnswerColor;
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
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: answerBColor == correctAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/TickMark.png"),
                    ),
                  ),
                  Visibility(
                    visible: answerBColor == incorrectAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/Cross.png"),
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
              if(correctAnswer == "C") {
                answerCColor = correctAnswerColor;
              } else {
                if(correctAnswer == "A") {
                  answerAColor = correctAnswerColor;
                } else {
                  answerBColor = correctAnswerColor;
                }
                answerCColor = incorrectAnswerColor;
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
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: answerCColor == correctAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/TickMark.png"),
                    ),
                  ),
                  Visibility(
                    visible: answerCColor == incorrectAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/Cross.png"),
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