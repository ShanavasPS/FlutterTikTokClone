import 'package:tiktokclone/network/network_calls.dart';

import '../utils/tiktok_strings.dart';
import 'answer_model.dart';
import 'flashcard_data.dart';
import 'mcq_data.dart';
import 'package:http/http.dart' as http;

class DataRepository {

  List<FlashcardData> followingItems = [];
  List<McqData> forYouItems = [];
  List<AnswerData> answers = [];
  bool isFollowingPageInitialized = false;
  bool isForYouPageInitialized = false;
  int tabIndex = 0; //To track selected screen
  int followingPageIndex = 0;
  int forYouPageIndex = 0;
  bool isFollowingPageLoading = false;
  bool isForYouPageLoading = false;
  late http.Client client = http.Client();

  Future<void> fetchNextFollowingItem() async {
    try {
      isFollowingPageLoading = true;
      final jsonData = await getNextFollowingItem(client);
      FlashcardData flashcardData = FlashcardData.fromJson(jsonData);
      followingItems.add(flashcardData);
    } catch (e) {
      // Handle error
    }
    isFollowingPageLoading = false;
    isFollowingPageInitialized = true;
  }

  Future<void> fetchNextForYouItem() async {
    try {
      isForYouPageLoading = true;
      final jsonData = await getNextForYouItem(client);
      McqData mcqData = McqData.fromJson(jsonData);
      final answerData = await revealAnswer(mcqData.id, client);
      AnswerData quizData = AnswerData.fromJson(answerData);
      forYouItems.add(mcqData);
      answers.add(quizData);
    } catch (e) {
      // Handle error
    }
    isForYouPageInitialized = true;
    isForYouPageLoading = false;
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
