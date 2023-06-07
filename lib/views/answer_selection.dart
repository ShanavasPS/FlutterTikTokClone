import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/model/answer_model.dart';
import 'package:tiktokclone/model/mcq_data.dart';

import '../widgets/answer_options.dart';

class AnswerSelectionView extends StatefulWidget {
  final McqData content;
  final AnswerData answer;
  const AnswerSelectionView({Key? key, required this.content, required this.answer}) : super(key: key);

  @override
  AnswerSelectionViewState createState() => AnswerSelectionViewState();
}

class AnswerSelectionViewState extends State<AnswerSelectionView> {
  List<bool> didTapOptions = [];

  @override
  void initState() {
    super.initState();
    didTapOptions = List.filled(widget.content.options.length, false);
  }

  void handleOptionTap(int index) {
    setState(() {
      didTapOptions[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final McqData content = widget.content;
    final AnswerData answer = widget.answer;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: content.options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return answerOptions(
          option: content.options[index].id,
          optionText: content.options[index].answer,
          answer: answer.correctOptions[0].id,
          didTapThisOption: didTapOptions[index],
          didTapAnOption: didTapOptions.contains(true),
          onTap: () => handleOptionTap(index),
        );
      },
    );
  }
}