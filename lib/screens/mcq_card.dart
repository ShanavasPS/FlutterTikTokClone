import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../model/mcq_data.dart';
import '../utils/tiktok_colors.dart';
import '../views/answer_selection.dart';
import '../views/user_info.dart';

class MCQFeed extends StatelessWidget {
  const MCQFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final McqData content =  context.read<DataProvider>().getMCQContent();
    final String mainTitle = content.question;

    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 73.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: Text(
                    mainTitle,
                    style: const TextStyle(
                      color: TikTokColors.selectedText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnswerSelectionView(),
                UserInfo(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}