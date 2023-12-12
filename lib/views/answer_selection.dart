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
    final index = context.watch<DataProvider>().forYouPageItemIndex;
    final McqData content =  context.watch<DataProvider>().forYouItems[index];
    final AnswerData answer = context.watch<DataProvider>().answers[index];
    final bool didTapAnOption = answer.didTapOptions.contains(true);
    final didTapOptions = answer.didTapOptions;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: content.options.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return answerOptions(
          optionId: content.options[index].id,
          optionText: content.options[index].answer,
          answer: answer,
          didTapThisOption: didTapOptions[index],
          didTapAnOption: didTapAnOption,
          onTap: () => handleOptionTap(context, index),
        );
      },
    );
  }
}