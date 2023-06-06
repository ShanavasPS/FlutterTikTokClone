import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tiktokclone/utils/common.dart';

import '../network/network_calls.dart';
import '../utils/tiktok_colors.dart';
import '../utils/tiktok_images.dart';
import '../utils/tiktok_strings.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/floating_action_buttons.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loader_indicator.dart';
import '../widgets/song_bar.dart';
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

  List<Map<String, dynamic>> followingItems = []; // List to store fetched items
  List<Map<String, dynamic>> forYouItems = []; // List to store fetched items
  List<Map<String, dynamic>> answers = []; // List to store fetched items

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

  @override
  void initState() {
    super.initState();
    print('inside state:');
    followingPageController.addListener(followingPageListener);
    forYouPageController.addListener(forYouPageListener);
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

  void followingPageListener() {
    print("inside followingPageListener");
    print(followingPageController.page);
    print(followingItems.length);
    if (followingPageController.page == followingItems.length) {
      print("condition met");
      fetchNextFollowingItem();
    }
  }

  void forYouPageListener() {
    print("inside forYouPageListener");
    print(forYouPageController.page);
    print(forYouItems.length);
    if (forYouPageController.page == forYouItems.length) {
      print("condition met");
      fetchNextForYouItem();
    }
  }

  Future<void> fetchNextFollowingItem() async {
    print("Inside fetchNextFollowingItem");
    setState(() {
      isLoading = true;
    });
    try {
      final item = await getNextFollowingItem();
      setState(() {
        followingItems.add(item);
        isLoading = false;
      });
      print("recived the below item");
      print(followingItems[0]);
      print(followingItems.length);
    } catch (e) {
      // Handle error
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchNextForYouItem() async {
    print("Inside fetchNextForYouItem");

    setState(() {
      isLoading = true;
    });
    try {
      final item = await getNextForYouItem();
      final answer = await revealAnswer(item["id"]);
      setState(() {
        forYouItems.add(item);
        answers.add(answer);
        isLoading = false;
      });
      print("recived the below item");
      print(forYouItems[0]);
      print(forYouItems.length);
    } catch (e) {
      // Handle error
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Inside build of main");
    String avatar = "";
    String playlist = TikTokStrings.playlist;
    Map<String, dynamic> content;
    if(tabIndex == 0) {
      if(followingPageIndex < followingItems.length) {
        content = followingItems[followingPageIndex];
        avatar = content["user"]["avatar"];
        playlist += content["playlist"];
      }
    } else {
      if(forYouPageIndex < forYouItems.length) {
        content = forYouItems[forYouPageIndex];
        avatar = content["user"]["avatar"];
        playlist += content["playlist"];
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
        buildTopBar(),
        Expanded(
            child: buildPageView()
        ),
        buildSongBarWidget(playlist),
      ],
    );
  }

  Widget buildTopBar() {

    final followingTextStyle = TextStyle(
        fontSize: 17.0,
        fontWeight: tabIndex == 0 ? FontWeight.bold: FontWeight.normal,
        color: tabIndex == 0 ? TikTokColors.selectedText: TikTokColors.unselectedText);

    final forYouTextStyle = TextStyle(
        fontSize: 17.0,
        fontWeight: tabIndex == 1 ? FontWeight.bold: FontWeight.normal,
        color: tabIndex == 1 ? TikTokColors.selectedText: TikTokColors.unselectedText);

    return SafeArea(
      child: Stack(
          children: [
            Container(
              height: 54,
              color: TikTokColors.statusBar,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 4),
                    child: TikTokImages.time,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                        actualTimeSpent,
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: TikTokColors.unselectedText)
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
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
                          },
                          child: Text(TikTokStrings.following,
                              style: followingTextStyle),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        GestureDetector(
                          onTap: (){
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
                          },
                          child: Text(TikTokStrings.forYou,
                              style: forYouTextStyle),
                        )
                      ]
                  ),
                  AnimatedPadding(
                    padding: EdgeInsets.only(top: 5, left: tabIndex == 1? measureTextWidth(TikTokStrings.forYou, forYouTextStyle) + 18 + 15: 0, right: tabIndex == 0 ? measureTextWidth(TikTokStrings.following, followingTextStyle)/2 + 15 + 18 : 0),
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: 30,
                      height: 4,
                      color: TikTokColors.selectedText,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8, right: 16),
              child: Align(
                  alignment: Alignment.topRight,
                  child: TikTokImages.search,
              ),
            ),
          ]
      ),
    );
  }

  Widget buildPageView() {
    print("inside buildPageView");
    if(tabIndex == 0) {
      return buildPageView1(followingPageController, followingItems.length);
    } else {
      return buildPageView2(forYouPageController, forYouItems.length);
    }
  }

  Widget buildPageView1(PageController controller, int itemCount) {
    return PageView.builder(
      controller: controller,
      itemCount: itemCount + 1,
      onPageChanged: (pageIndex) {
        print("Inside page1 onPageChanged1");
        followingPageIndex = pageIndex;
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        print("Index inside itemBuilder Page 1 is $index");
        if (index < itemCount) {
          return FlashCardFeed(
              content: followingItems[index]
          );
        } else {
          return buildLoaderIndicator(isLoading);
        }
      },
    );
  }

  Widget buildPageView2(PageController controller, int itemCount) {
    return PageView.builder(
      controller: controller,
      itemCount: itemCount + 1,
      onPageChanged: (pageIndex) {
        print("Inside page2 onPageChanged");
        forYouPageIndex = pageIndex;
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        print("Index inside itemBuilder Page 2 is $index");
        if (index < itemCount) {
          print("setting a forYou page");
          print(controller.page);
          return MCQFeed(
            content: forYouItems[index],
            answer: answers[index],
          );
        } else {
          return buildLoaderIndicator(isLoading);
        }
      },
    );
  }
}