import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tiktokclone/network/network_calls.dart';

import '../utils/tiktok_strings.dart';
import '../model/answer_model.dart';
import '../model/flashcard_data.dart';
import '../model/mcq_data.dart';
import 'package:http/http.dart' as http;

class DataProvider with ChangeNotifier {

  List<FlashcardData> followingItems = [];
  List<McqData> forYouItems = [];
  List<AnswerData> answers = [];
  bool isFollowingPageInitialized = false;
  bool isForYouPageInitialized = false;
  int tabIndex = 0; //To track selected screen
  int _followingPageIndex = 0;
  int _forYouPageIndex = 0;
  int _followingPageItemIndex = 0;
  int _forYouPageItemIndex = 0;

  bool isFollowingPageLoading = false;
  bool isForYouPageLoading = false;
  late http.Client client = http.Client();
  final int prefetchCount = 5;
  final PageController followingPageController = PageController(initialPage: 0);
  final PageController forYouPageController = PageController(initialPage: 0);
  bool showFlashCardBackView = false;

  int get followingPageIndex => _followingPageIndex;
  int get forYouPageIndex => _forYouPageIndex;
  int get followingPageItemIndex => _followingPageItemIndex;
  int get forYouPageItemIndex => _forYouPageItemIndex;

  DataProvider() {
    initPageListeners();
    initializeData();
  }

  @override
  void dispose() {
    followingPageController.dispose();
    forYouPageController.dispose();
    super.dispose();
  }

  void initializeData() {
    fetchNextFollowingItem();
    fetchNextForYouItem();
  }

  void initPageListeners() {
    followingPageController.addListener(() {
      pageListener(followingPageController, fetchNextFollowingItem);
    });

    forYouPageController.addListener(() {
      pageListener(forYouPageController, fetchNextForYouItem);
    });
  }

  void pageListener(PageController controller, Future<void> Function() fetchData) {
    final double currentPage = controller.page ?? 0;
    final int itemCount = getItemCount();
    if (currentPage >= itemCount - 1 && !isLoading()) {
      fetchData();
    } else if (currentPage < itemCount - prefetchCount) {
      fetchNextItem(); // Prefetch the next items if the current page is far from the end
    }
  }

  bool isLoading() {
    return (tabIndex == 0)
        ? isFollowingPageLoading
        : isForYouPageLoading;
  }

  int getItemCount() {
    return (tabIndex == 0)
        ? followingItems.length
        : forYouItems.length;
  }

  void toggleFlashCardView() {
    showFlashCardBackView = !showFlashCardBackView;
    if(!showFlashCardBackView) {
      followingItems[_followingPageItemIndex].ratingSelection = List.filled(5, false);
    }
    notifyListeners();
  }

  void updateTabIndex(int index) {
      if(tabIndex != index) {
        tabIndex = index;
        notifyListeners();
      }
  }

  void updateMCQAnswerSelection(int index, bool selected) {
    print("updateMCQAnwerSelection $index");
    answers[_forYouPageItemIndex].didTapOptions[index] = true;
    notifyListeners();
  }

  void updateRatingSelection(int index, bool selected) {
    followingItems[_followingPageItemIndex].ratingSelection[index] = true;
    notifyListeners();
  }

  FlashcardData getFlashCardContent() {
    return followingItems[followingPageItemIndex];
  }

  McqData getMCQContent() {
    return forYouItems[forYouPageItemIndex];
  }

  AnswerData getAnswers() {
    return answers[forYouPageItemIndex];
  }

  void updateFollowingPageIndex(int index) {
    _followingPageIndex= index;
  }

  void updateFollowingPageItemIndex(int index) {
    _followingPageItemIndex = index;
  }

  void updateForYouPageIndex(int index) {
    _forYouPageIndex= index;
  }

  void updateForYouPageItemIndex(int index) {
    _forYouPageItemIndex = index;
  }

  List<bool> getRatings() {
    return followingItems[_followingPageItemIndex].ratingSelection;
  }

  Future<void> fetchNextItem() async {
    if (tabIndex == 0) {
      fetchNextFollowingItem();
    } else {
      fetchNextForYouItem();
    }
  }

  Future<void> fetchData(Future<void> Function() fetchDataMethod) async {
    try {
      await fetchDataMethod();
    } catch (e) {
      // Handle error
    } finally {
    }
  }

  Future<void> fetchNextFollowingItem() async {
    try {
      isFollowingPageLoading = true;
      final jsonData = await getNextFollowingItem(client);
      FlashcardData flashcardData = FlashcardData.fromJson(jsonData);
      followingItems.add(flashcardData);
      notifyListeners();
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
      notifyListeners();
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
      if (_followingPageIndex < followingItems.length) {
        avatar = followingItems[_followingPageIndex].user.avatar;
        playlist += followingItems[_followingPageIndex].playlist;
      }
    } else {
      if (_forYouPageIndex < forYouItems.length) {
        avatar = forYouItems[_forYouPageIndex].user.avatar;
        playlist += forYouItems[_forYouPageIndex].playlist;
      }
    }

    return [avatar, playlist];
  }
}
