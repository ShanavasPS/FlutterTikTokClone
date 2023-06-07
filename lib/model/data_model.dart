import 'package:tiktokclone/network/network_calls.dart';

import '../utils/tiktok_strings.dart';
import 'answer_model.dart';
import 'flashcard_data.dart';
import 'mcq_data.dart';

class DataRepository {

  List<FlashcardData> followingItems = [];
  List<McqData> forYouItems = [];
  List<AnswerData> answers = [];
  bool isFollowingPageInitialized = false;
  bool isForYouPageInitialized = false;
  int tabIndex = 0; //To track selected screen
  int followingPageIndex = 0;
  int forYouPageIndex = 0;
  bool isLoading = false; // Flag to track loading state

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
    isFollowingPageInitialized = true;
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
    isForYouPageInitialized = true;
  }

  List<String> updateAvatarAndPlaylist() {
    String avatar = "";
    String playlist = TikTokStrings.playlist;

    if (tabIndex == 0) {
      if (followingPageIndex < followingItems.length) {
        avatar = followingItems[followingPageIndex].user.avatar;
        playlist += followingItems[followingPageIndex].playlist;
      }
    } else {
      if (forYouPageIndex < forYouItems.length) {
        avatar = forYouItems[forYouPageIndex].user.avatar;
        playlist += forYouItems[forYouPageIndex].playlist;
      }
    }

    return [avatar, playlist];
  }
}
