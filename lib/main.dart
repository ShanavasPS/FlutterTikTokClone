import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tittokclone/networkcalls.dart';

void main() {
  runApp(TikTokApp());
}

class TikTokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set the status bar color to black
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    return MaterialApp(
      title: 'TikTok',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionsBuilder(),
            TargetPlatform.iOS: CustomPageTransitionsBuilder(),
          },
        ),
      ),
      home: HomePage(),
    );
  }
}

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (route.isFirst) {
      return child;
    }
    // Customize your transition animation here
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Color unselectedTextColor = Colors.white70;
  Color selectedTextColor = Colors.white;
  Color followingTextColor = Colors.white;
  Color forYouTextColor = Colors.white70;
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
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_lastLifecycleState == AppLifecycleState.resumed) {
        setState(() {
          _totalSessionDuration = DateTime.now().difference(_sessionStartTime);
          seconds = _totalSessionDuration.inSeconds.remainder(60);
          minutes = _totalSessionDuration.inMinutes.remainder(60);
          hours = _totalSessionDuration.inHours;
          int preFix = seconds;
          String postFix = "s";
          if(hours > 0) {
            preFix = hours;
            postFix = "h";
          } else if(minutes > 0) {
            preFix = minutes;
            postFix = "m";
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
          GradientBackground(),
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
            color: const Color(0xFFFFFFFF).withOpacity(0.5),
          )
      ),
    ) : SizedBox.shrink();
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

    const String followingText = "Following";
    const String forYouText = "For You";

    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: 54,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 4),
                  child: Image.asset("images/Time.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                      actualTimeSpent,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: unselectedTextColor)
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
                            followingTextColor = selectedTextColor;
                            followingWeight = FontWeight.bold;
                            forYouTextColor = unselectedTextColor;
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
                        child: Text(followingText,
                            style: followingTextStyle),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      GestureDetector(
                        onTap: (){
                          print("For You tapped.");
                          setState(() {
                            followingTextColor = unselectedTextColor;
                            followingWeight = FontWeight.normal;
                            forYouTextColor = selectedTextColor;
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
                        child: Text(forYouText,
                            style: forYouTextStyle),
                      )
                    ]
                ),
                AnimatedPadding(
                  padding: EdgeInsets.only(top: 5, left: tabIndex == 1? measureTextWidth(forYouText, forYouTextStyle) + 18 + 15: 0, right: tabIndex == 0 ? measureTextWidth(followingText, followingTextStyle)/2 + 15 + 18 : 0),
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 30,
                    height: 4,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 16),
            child: Align(
                alignment: Alignment.topRight,
                child: Image.asset("images/Search.png")
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
        color: const Color(0xFF161616),
        height: 36,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 4.0),
              child: Image.asset("images/Play.png"),
            ),
            const Text(
              'Playlist • Unit 5: Period 5: 1844-1877',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset("images/Arrow.png"),
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

Widget buildCustomFloatingActionButton(String imageName, double height, double weight, String text) {
  bool showLabel = true;
  if(text == "") {
    showLabel = false;
  }
  return FloatingActionButton(
    onPressed: () {
      // Handle button press
    },
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imageName,
          height: height,
          width: weight,
        ),
        Visibility(
          visible: showLabel,
          child: Text(
              text
          ),
        ),
      ],
    ),
  );
}

Widget buildCustomFloatingNetworkActionButton(String imageName, String errorImage, double height, double weight, String text) {
  bool showLabel = true;
  if(text == "") {
    showLabel = false;
  }
  return FloatingActionButton(
    onPressed: () {
      // Handle button press
    },
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          imageName,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              errorImage,
              height: height,
              width: weight,
            );
          },
        ),
        Visibility(
          visible: showLabel,
          child: Text(
              text
          ),
        ),
      ],
    ),
  );
}

Widget buildFloatingActionButton(String avatar) {
  return Padding(
    padding: EdgeInsets.only(bottom: 36.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildCustomFloatingNetworkActionButton(avatar, 'images/Ellipse21.png', 55, 55, ""),
        SizedBox(height: 16),
        buildCustomFloatingActionButton('images/Like.png', 32, 30, "87"),
        SizedBox(height: 16),
        buildCustomFloatingActionButton('images/Comments.png', 32, 30, "2"),
        SizedBox(height: 16),
        buildCustomFloatingActionButton('images/Share.png', 32, 30, "17"),
        SizedBox(height: 16),
        buildCustomFloatingActionButton('images/Bookmark.png', 32, 30, "203"),
        SizedBox(height: 16),
        buildCustomFloatingActionButton('images/Refresh.png', 32, 30, "Flip"),
      ],
    ),
  );
}

Widget buildBottomNavigationBar(BuildContext context) {
  return Theme(
    data: Theme.of(context).copyWith(
      canvasColor: Colors.black, // Set the background color to black
    ),
    child: BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Image.asset("images/Home.png")
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Image.asset("images/Discover.png")
          ),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Image.asset("images/Activity.png")
          ),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Image.asset("images/Bookmarks.png")
          ),
          label: 'Bookmarks',
        ),
        BottomNavigationBarItem(
          icon: Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Image.asset("images/Profile.png")
          ),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color.fromRGBO(255, 255, 255, 0.4),
      showUnselectedLabels: true,
    ),
  );
}

class FlashCardFeed extends StatefulWidget {
  final Map<String, dynamic> content;
  FlashCardFeed({required this.content});

  @override
  FlashCardFeedState createState() => FlashCardFeedState();
}

class FlashCardFeedState extends State<FlashCardFeed> {
  FlashCardFeedState() : super();

  bool showBackOfFlashCard = false;

  @override
  void initState() {
    super.initState();
    print('inside state:');
  }

  void updateFlashCardFeedState(bool showBackOfFlashCard) {
    // Update the state value in the parent widget
    setState(() {
      print("Inside Flash Card Feed State $showBackOfFlashCard");
      // Update the state value with the new value received from the child
      this.showBackOfFlashCard = showBackOfFlashCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> content = widget.content;

    String flashcardFrontText = content["flashcard_front"];
    String flashcardBackText = content["flashcard_back"];

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
      child: GestureDetector(
        onTap: () {
          print("container tapped");
          print(showBackOfFlashCard);
          setState(() {
            print("inside set state");
            showBackOfFlashCard = !showBackOfFlashCard;
          });
        },
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 73.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        flashcardFrontText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  FlashCardBack(flashcardBackText: flashcardBackText, showBackOfFlashCard: showBackOfFlashCard, updateFlashCardFeedState: updateFlashCardFeedState),
                  buildUserInfo(username, description),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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

Widget GradientBackground() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF001D28),
          Color(0xFF00425A),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
      ),
    ),
  );
}

Widget buildUserInfo(String username, String description) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class FlashCardBack extends StatefulWidget {
  final String flashcardBackText;
  final bool showBackOfFlashCard;
  final Function(bool) updateFlashCardFeedState;
  FlashCardBack({required this.flashcardBackText, required this.showBackOfFlashCard, required this.updateFlashCardFeedState});

  @override
  FlashCardBackState createState() => FlashCardBackState();
}

class FlashCardBackState extends State<FlashCardBack> {
  FlashCardBackState() : super();

  bool showBack = false;

  @override
  void initState() {
    super.initState();
    print("Inside initState");
    print('inside FlashCardBackState: $showBack');
  }

  @override
  void didUpdateWidget(covariant FlashCardBack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBackOfFlashCard != oldWidget.showBackOfFlashCard) {
      setState(() {
        showBack = widget.showBackOfFlashCard;
      });
    }
  }

  void updateFlashCardBackState(bool showBackOfFlashCard) {
    // Update the state value in the parent widget
    setState(() {
      print("Inside FlashCardBackState $showBackOfFlashCard");
      // Update the state value with the new value received from the child
      showBack = showBackOfFlashCard;
      widget.updateFlashCardFeedState(showBackOfFlashCard);
    });
  }

  Color defaultAnswerColor = const Color(0xFFFFFFFF).withOpacity(0.2);
  Color decriptionTextColor = const Color(0xFFFFFFFF).withOpacity(0.7);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showBack,
      child: Column(
        children: [
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: defaultAnswerColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Answer",
                style: TextStyle(
                  color: Color(0xFF2DC59F),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.2,
                ),
                child: Text(
                  widget.flashcardBackText,
                  style: TextStyle(
                    color: decriptionTextColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          RatingView(showBackOfFlashCard: showBack, updateFlashCardBackState: updateFlashCardBackState),
        ],
      ),
    );
  }
}

class RatingView extends StatefulWidget {
  final bool showBackOfFlashCard;
  final Function(bool) updateFlashCardBackState;
  RatingView({required this.showBackOfFlashCard, required this.updateFlashCardBackState});

  @override
  RatingViewState createState() => RatingViewState();
}

class RatingViewState extends State<RatingView> {
  RatingViewState() : super();

  @override
  void initState() {
    super.initState();
    print('inside state:');
  }

  bool showButtonOne = true;
  bool showButtonTwo = true;
  bool showButtonThree = true;
  bool showButtonFour = true;
  bool showButtonFive = true;
  bool isColoredBoxSelected = false;

  Color princetonOrange = const Color(0xFFF17D23);
  Color mellowApricot = const Color(0xFFFBB668);
  Color mustard = const Color(0xFFFFD449);
  Color darkGreenColor = const Color(0xFF16624F);
  Color illuminatingEmerald = const Color(0xFF1F8A70);

  Color decriptionTextColor = const Color(0xFFFFFFFF).withOpacity(0.7);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 5),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "How well did you know this?",
              style: TextStyle(
                color: decriptionTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Visibility(
              visible: showButtonOne,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!isColoredBoxSelected) {
                        showButtonTwo = false;
                        showButtonThree = false;
                        showButtonFour = false;
                        showButtonFive = false;
                        isColoredBoxSelected = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: princetonOrange,
                    ),
                    width: (MediaQuery.of(context).size.width - 8 * 6) / 5,
                    height: 52,
                    child: const Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: showButtonOne,
                child: SizedBox(width: 8)
            ),
            Visibility(
              visible: showButtonTwo,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!isColoredBoxSelected) {
                        showButtonOne = false;
                        showButtonThree = false;
                        showButtonFour = false;
                        showButtonFive = false;
                        isColoredBoxSelected = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: mellowApricot,
                    ),
                    height: 52,
                    child: const Center(
                      child: Text(
                        "2",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: showButtonTwo,
                child: SizedBox(width: 8)
            ),
            Visibility(
              visible: showButtonThree,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!isColoredBoxSelected) {
                        showButtonOne = false;
                        showButtonTwo = false;
                        showButtonFour = false;
                        showButtonFive = false;
                        isColoredBoxSelected = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: mustard,
                    ),
                    height: 52,
                    child: const Center(
                      child: Text(
                        "3",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: showButtonThree,
                child: SizedBox(width: 8)
            ),
            Visibility(
              visible: showButtonFour,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!isColoredBoxSelected) {
                        showButtonOne = false;
                        showButtonTwo = false;
                        showButtonThree = false;
                        showButtonFive = false;
                        isColoredBoxSelected = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: darkGreenColor,
                    ),
                    height: 52,
                    child: const Center(
                      child: Text(
                        "4",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
                visible: showButtonOne,
                child: SizedBox(width: 8)
            ),
            Visibility(
              visible: showButtonFive,
              child: Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if(!isColoredBoxSelected) {
                        showButtonOne = false;
                        showButtonTwo = false;
                        showButtonThree = false;
                        showButtonFour = false;
                        isColoredBoxSelected = true;
                      } else {
                        widget.updateFlashCardBackState(false);
                      }
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: illuminatingEmerald,
                    ),
                    height: 52,
                    child: const Center(
                      child: Text(
                        "5",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AnswerSelectionView extends StatefulWidget {
  final Map<String, dynamic> content;
  final Map<String, dynamic> answer;
  AnswerSelectionView({required this.content, required this.answer});

  @override
  AnswerSelectionViewState createState() => AnswerSelectionViewState();
}

class AnswerSelectionViewState extends State<AnswerSelectionView> {
  AnswerSelectionViewState() : super();

  @override
  void initState() {
    super.initState();
    print('inside state:');
  }

  Color correctAnswerColor = Color(0xFF28B18F);
  Color incorrectAnswerColor = Color(0xFFDC5F5F);
  Color answerAColor = Color(0xFFFFFFFF).withOpacity(0.2);
  Color answerBColor = Color(0xFFFFFFFF).withOpacity(0.2);
  Color answerCColor = Color(0xFFFFFFFF).withOpacity(0.2);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> content = widget.content;
    final Map<String, dynamic> answer = widget.answer;

    // Access the 'options' array
    final List<dynamic> options = content['options'];
    // Find the option with id 'A'
    final Map<String, dynamic> optionA = options.firstWhere((
        option) => option['id'] == 'A');
    // Read the answer from the optionA
    final String answerA = optionA['answer'];
    // Find the option with id 'B'
    final Map<String, dynamic> optionB = options.firstWhere((
        option) => option['id'] == 'B');
    // Read the answer from the optionB
    final String answerB = optionB['answer'];
    // Find the option with id 'C'
    final Map<String, dynamic> optionC = options.firstWhere((
        option) => option['id'] == 'C');
    // Read the answer from the optionC
    final String answerC = optionC['answer'];

    // Extract the 'correct_options' array
    List<dynamic> correctOptions = answer['correct_options'];

    // Extract the first item from 'correct_options' array
    Map<String, dynamic> firstOption = correctOptions[0];

    // Extract the 'id' value from the first option
    String correctAnswer = firstOption['id'];

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print("answer a tapped");
            setState(() {
              print("inside set state");
              // Change the color when pressed
              // Set the new color value based on your requirement
              if(correctAnswer == "A") {
                answerAColor = correctAnswerColor;
              } else {
                if(correctAnswer == "B") {
                  answerBColor = correctAnswerColor;
                } else {
                  answerCColor = correctAnswerColor;
                }
                answerAColor = incorrectAnswerColor;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: answerAColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  12, 16, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      answerA,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: answerAColor == correctAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/TickMark.png"),
                    ),
                  ),
                  Visibility(
                    visible: answerAColor == incorrectAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/Cross.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            print("answer b tapped");
            setState(() {
              print("inside set state");
              // Change the color when pressed
              // Set the new color value based on your requirement
              if(correctAnswer == "B") {
                answerBColor = correctAnswerColor;
              } else {
                if(correctAnswer == "A") {
                  answerAColor = correctAnswerColor;
                } else {
                  answerCColor = correctAnswerColor;
                }
                answerBColor = incorrectAnswerColor;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: answerBColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  12, 16, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      answerB,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: answerBColor == correctAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/TickMark.png"),
                    ),
                  ),
                  Visibility(
                    visible: answerBColor == incorrectAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/Cross.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            print("answer c tapped");
            setState(() {
              print("inside set state");
              if(correctAnswer == "C") {
                answerCColor = correctAnswerColor;
              } else {
                if(correctAnswer == "A") {
                  answerAColor = correctAnswerColor;
                } else {
                  answerBColor = correctAnswerColor;
                }
                answerCColor = incorrectAnswerColor;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: answerCColor,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  12, 16, 12, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      answerC,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: answerCColor == correctAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/TickMark.png"),
                    ),
                  ),
                  Visibility(
                    visible: answerCColor == incorrectAnswerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset("images/Cross.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}