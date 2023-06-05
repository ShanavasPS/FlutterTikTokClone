import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tittokclone/widgets/answer_selection.dart';
import 'package:tittokclone/utils/common.dart';

class MCQFeed extends StatefulWidget {
  final Map<String, dynamic> content;
  final Map<String, dynamic> answer;
  MCQFeed({required this.content, required this.answer});

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
    final Map<String, dynamic> content = widget.content;
    final Map<String, dynamic> answer = widget.answer;

    final String mainTitle = content["question"];
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
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 73.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: Text(
                      mainTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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