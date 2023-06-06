import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tiktokclone/utils/common.dart';

import '../model/answer_model.dart';
import '../model/data_model.dart';
import '../model/flashcard_data.dart';
import '../model/mcq_data.dart';
import '../utils/tiktok_strings.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/floating_action_buttons.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loader_indicator.dart';
import '../widgets/song_bar.dart';
import '../widgets/top_bar.dart';
import 'flash_card.dart';
import 'mcq_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  final PageController followingPageController = PageController(initialPage: 0);
  final PageController forYouPageController = PageController(initialPage: 0);

  List<FlashcardData> followingItems = [];
  List<McqData> forYouItems = [];
  List<AnswerData> answers = [];

  int tabIndex = 0; //To track selected screen
  int followingPageIndex = 0;
  int forYouPageIndex = 0;

  bool isLoading = false; // Flag to track loading state
  bool isFollowingPageInitialized = false;
  bool isForYouPageInitialized = false;

  AppLifecycleState _lastLifecycleState = AppLifecycleState.resumed;

  DateTime _sessionStartTime = DateTime.now();

  Duration _totalSessionDuration = Duration.zero;

  String actualTimeSpent =  "";

  late Timer _timer;

  DataRepository dataRepository = DataRepository();

  @override
  void initState() {
    super.initState();
    print('inside state:');
    followingPageController.addListener(() {
      pageListener(followingPageController, fetchNextFollowingItem);
    });

    forYouPageController.addListener(() {
      pageListener(forYouPageController, fetchNextForYouItem);
    });

    if(tabIndex == 0) {
      fetchNextFollowingItem();
      isFollowingPageInitialized = true;
    } else {
      fetchNextForYouItem();
      isForYouPageInitialized = true;
    }
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_lastLifecycleState == AppLifecycleState.resumed) {
        setState(() {
          _totalSessionDuration = DateTime.now().difference(_sessionStartTime);
          actualTimeSpent = getDuration(_totalSessionDuration);
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _sessionStartTime = DateTime.now();
    } else if (state == AppLifecycleState.paused) {
      _totalSessionDuration += DateTime.now().difference(_sessionStartTime);
    }
    _lastLifecycleState = state;
  }

  void pageListener(PageController controller, Future<void> Function() fetchData) {
    print("Inside pageListener");
    print(controller.page);
    if((tabIndex == 0 && controller.page == followingItems.length) ||
        (tabIndex == 1 && controller.page == forYouItems.length)) {
      print("condition met");
      fetchData();
    }
  }

  Future<void> fetchData(Future<void> Function() fetchDataMethod) async {
    print("Inside fetchData");

    setState(() {
      isLoading = true;
    });

    try {
      await fetchDataMethod();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchNextFollowingItem() async {
    fetchData(dataRepository.fetchNextFollowingItem);
  }

  Future<void> fetchNextForYouItem() async {
    fetchData(dataRepository.fetchNextForYouItem);
  }

  @override
  Widget build(BuildContext context) {
    print("Inside build of main");
    String avatar = "";
    String playlist = TikTokStrings.playlist;
    followingItems = dataRepository.followingItems;
    forYouItems = dataRepository.forYouItems;
    answers = dataRepository.answers;

    if(tabIndex == 0) {
      if(followingPageIndex < followingItems.length) {
        avatar = followingItems[followingPageIndex].user.avatar;
        playlist += followingItems[followingPageIndex].playlist;
      }
    } else {
      if(forYouPageIndex < forYouItems.length) {
        avatar = forYouItems[forYouPageIndex].user.avatar;
        playlist += forYouItems[forYouPageIndex].playlist;
      }
    }

    return Scaffold(
      body: Stack(
          children: [
            gradientBackground(),
            buildForeground(playlist),
          ]
      ),
      floatingActionButton: buildFloatingActionButtons(avatar, tabIndex),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildForeground(String playlist) {
    return Column(
      children: [
        buildTopBar(tabIndex, actualTimeSpent, followingTapped, forYouTapped),
        Expanded(
            child: buildPageView()
        ),
        buildSongBarWidget(playlist),
      ],
    );
  }

  void followingTapped() {
    print("Following tapped.");
    setState(() {
      tabIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        followingPageController.jumpToPage(0);
        // Manually set the page to 0
      });
      if(!isFollowingPageInitialized) {
        fetchNextFollowingItem();
        isFollowingPageInitialized = true;
      }
    });
  }

  void forYouTapped() {
    print("For You tapped.");
    setState(() {
      tabIndex = 1;
      print("for you page index is $forYouPageIndex");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        forYouPageController.jumpToPage(0);
        // Manually set the page to 0
      });
      if(!isForYouPageInitialized) {
        fetchNextForYouItem();
        isForYouPageInitialized = true;
      }
    });
  }

  Widget buildPageView() {
    print("inside buildPageView");
    final PageController controller = tabIndex == 0
        ? followingPageController
        : forYouPageController;
    final int itemCount = tabIndex == 0
        ? followingItems.length
        : forYouItems.length;

    return PageView.builder(
      controller: controller,
      itemCount: itemCount + 1,
      onPageChanged: (pageIndex) {
        print("Inside onPageChanged");
        if (tabIndex == 0) {
          followingPageIndex = pageIndex;
        } else {
          forYouPageIndex = pageIndex;
        }
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        print("Index inside itemBuilder is $index");
        if (index < itemCount) {
          if (tabIndex == 0) {
            return FlashCardFeed(content: followingItems[index]);
          } else {
            print("setting a forYou page");
            print(controller.page);
            return MCQFeed(
              content: forYouItems[index],
              answer: answers[index],
            );
          }
        } else {
          return buildLoaderIndicator(isLoading);
        }
      },
    );
  }
}