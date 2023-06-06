import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tiktokclone/networkcalls.dart';
import 'mcq_card.dart';
import 'flash_card.dart';
import 'package:tiktokclone/utils/common.dart';
import 'package:tiktokclone/utils/tiktok_colors.dart';
import 'package:tiktokclone/utils/tiktok_strings.dart';
import 'package:tiktokclone/utils/tiktok_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Color followingTextColor = TikTokColors.selectedText;
  Color forYouTextColor = TikTokColors.unselectedText;
  FontWeight followingWeight = FontWeight.bold;
  FontWeight forYouWeight = FontWeight.normal;
  final PageController followingPageController = PageController(initialPage: 0);
  final PageController forYouPageController = PageController(initialPage: 0);
  List<Map<String, dynamic>> followingItems = []; // List to store fetched items
  List<Map<String, dynamic>> forYouItems = []; // List to store fetched items
  List<Map<String, dynamic>> answers = []; // List to store fetched items
  int currentPage = 0; // Current page of items
  bool isLoading = false; // Flag to track loading state
  int tabIndex = 0; //To track selected screen
  bool didReceiveAvatarUrl = false;
  bool isFollowingPageInitialized = false;
  bool isForYouPageInitialized = false;
  int followingPageIndex = 0;
  int forYouPageIndex = 0;

  AppLifecycleState _lastLifecycleState = AppLifecycleState.resumed;
  DateTime _sessionStartTime = DateTime.now();
  Duration _totalSessionDuration = Duration.zero;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
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
          seconds = _totalSessionDuration.inSeconds.remainder(60);
          minutes = _totalSessionDuration.inMinutes.remainder(60);
          hours = _totalSessionDuration.inHours;
          int preFix = seconds;
          String postFix = TikTokStrings.secondPostFix;
          if(hours > 0) {
            preFix = hours;
            postFix = TikTokStrings.hourPostFix;
          } else if(minutes > 0) {
            preFix = minutes;
            postFix = TikTokStrings.minutePostFix;
          }
          actualTimeSpent = "$preFix $postFix";
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

  void updateButtonState(bool value) {
    setState(() {
      didReceiveAvatarUrl = value;
    });
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

        currentPage++;
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
        currentPage++;
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
    if(followingItems.isNotEmpty) {
      avatar = followingItems[0]["user"]["avatar"];
    }
    return Scaffold(
      body: Stack(
          children: [
            gradientBackground(),
            buildForeground(),
          ]
      ),
      floatingActionButton: buildFloatingActionButton(avatar),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildForeground() {
    return Column(
      children: [
        buildTopBar(),
        Expanded(
            child: buildPageView()
        ),
        buildSongBarWidget(),
      ],
    );
  }

  Widget _buildLoaderIndicator() {
    return isLoading ? Center(
      child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: TikTokColors.progressIndicatorColor,
          )
      ),
    ) : const SizedBox.shrink();
  }

  double measureTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    return textPainter.width;
  }

  Widget buildTopBar() {

    final followingTextStyle = TextStyle(
        fontSize: 17.0,
        fontWeight: followingWeight,
        color: followingTextColor);

    final forYouTextStyle = TextStyle(
        fontSize: 17.0,
        fontWeight: forYouWeight,
        color: forYouTextColor);

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
                              followingTextColor = TikTokColors.selectedText;
                              followingWeight = FontWeight.bold;
                              forYouTextColor = TikTokColors.unselectedText;
                              forYouWeight = FontWeight.normal;
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
                              followingTextColor = TikTokColors.unselectedText;
                              followingWeight = FontWeight.normal;
                              forYouTextColor = TikTokColors.selectedText;
                              forYouWeight = FontWeight.bold;
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

  Widget buildSongBarWidget() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: TikTokColors.playlistBackgroundColor,
        height: 36,
        child: Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 4.0),
              child: TikTokImages.play,
            ),
            Text(
              'Playlist • Unit 5: Period 5: 1844-1877',
              style: TextStyle(
                color: TikTokColors.selectedText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: TikTokImages.arrow,
            ),
          ],
        ),
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
      controller: followingPageController,
      itemCount: followingItems.length + 1,
      onPageChanged: (pageIndex) {
        print("Inside page1 onPageChanged1");
        followingPageIndex = pageIndex;
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        print("Index inside itemBuilder Page 1 is $index");
        if (index < followingItems.length) {
          return FlashCardFeed(
              content: followingItems[index]
          );
        } else {
          return _buildLoaderIndicator();
        }
      },
    );
  }

  Widget buildPageView2(PageController controller, int itemCount) {
    return PageView.builder(
      controller: forYouPageController,
      itemCount: forYouItems.length + 1,
      onPageChanged: (pageIndex) {
        print("Inside page2 onPageChanged");
        forYouPageIndex = pageIndex;
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        print("Index inside itemBuilder Page 2 is $index");
        if (index < forYouItems.length) {
          print("setting a forYou page");
          print(forYouPageController.page);
          return MCQFeed(
            content: forYouItems[index],
            answer: answers[index],
          );
        } else {
          return _buildLoaderIndicator();
        }
      },
    );
  }
}