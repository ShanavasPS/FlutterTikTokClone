import 'package:tiktokclone/network/network_calls.dart';

import 'answer_model.dart';
import 'flashcard_data.dart';
import 'mcq_data.dart';

class DataRepository {

  List<FlashcardData> followingItems = [];
  List<McqData> forYouItems = [];
  List<AnswerData> answers = [];

  Future<void> fetchNextFollowingItem() async {
    try {
      final jsonData = await getNextFollowingItem();
      FlashcardData flashcardData = FlashcardData.fromJson(jsonData);
      followingItems.add(flashcardData);
      print("received the below item");
      print(followingItems[0]);
      print(followingItems.length);
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> fetchNextForYouItem() async {
    try {
      final jsonData = await getNextForYouItem();
      McqData mcqData = McqData.fromJson(jsonData);
      final answerData = await revealAnswer(mcqData.id);
      AnswerData quizData = AnswerData.fromJson(answerData);
      forYouItems.add(mcqData);
      answers.add(quizData);
      print("received the below item");
      print(forYouItems[0]);
      print(forYouItems.length);
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
}
