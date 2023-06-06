import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/model/answer_model.dart';

import '../model/mcq_data.dart';
import '../utils/tiktok_colors.dart';
import '../views/answer_selection.dart';
import '../widgets/user_info.dart';


class MCQFeed extends StatefulWidget {
  final McqData content;
  final AnswerData answer;
  const MCQFeed({super.key, required this.content, required this.answer});

  @override
  MCQFeedState createState() => MCQFeedState();
}

class MCQFeedState extends State<MCQFeed> {
  MCQFeedState() : super();

  @override
  void initState() {
    super.initState();
    print('inside state:');
  }

  @override
  Widget build(BuildContext context) {
    final McqData content = widget.content;
    final AnswerData answer = widget.answer;

    final String mainTitle = content.question;
    final String username = content.user.name;
    final String description = content.description;

    return Container(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnswerSelectionView(content: content, answer: answer),
                buildUserInfo(username, description),
              ],
            ),
          ],
        ),
      ),
    );
  }
}