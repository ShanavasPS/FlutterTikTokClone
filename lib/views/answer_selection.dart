import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiktokclone/model/answer_model.dart';
import 'package:tiktokclone/model/mcq_data.dart';

import '../providers/data_provider.dart';
import 'answer_options.dart';

class AnswerSelectionView extends StatelessWidget {
  const AnswerSelectionView({super.key});

  void handleOptionTap(BuildContext context, int index) {
    context.read<DataProvider>().updateMCQAnswerSelection(index, true);
  }

  @override
  Widget build(BuildContext context) {
    final McqData content =  context.watch<DataProvider>().getMCQContent();
    final AnswerData answers = context.watch<DataProvider>().getAnswers();
    final didTapOptions = answers.didTapOptions;
    final bool didTapAnOption = didTapOptions.contains(true);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: content.options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return answerOptions(
          optionId: content.options[index].id,
          optionText: content.options[index].answer,
          answer: answers,
          didTapThisOption: didTapOptions[index],
          didTapAnOption: didTapAnOption,
          onTap: () => handleOptionTap(context, index),
        );
      },
    );
  }
}