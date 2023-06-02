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

class _HomePageState extends State<HomePage> {
  Color unselectedTextColor = Colors.white70;
  Color selectedTextColor = Colors.white;
  Color followingTextColor = Colors.white;
  Color forYouTextColor = Colors.white70;
  FontWeight followingWeight = FontWeight.bold;
  FontWeight forYouWeight = FontWeight.normal;
  String selectedFeed = "Following";
  String nextItem = ''; // Initial next item value
  final PageController followingPageController = PageController(initialPage: 0, viewportFraction: 1);
  final PageController forYouPageController = PageController(initialPage: 0, viewportFraction: 1);
  List<Map<String, dynamic>> followingItems = []; // List to store fetched items
  List<Map<String, dynamic>> forYouItems = []; // List to store fetched items
  int currentPage = 0; // Current page of items
  bool isLoading = false; // Flag to track loading state
  int tabIndex = 0; //To track selected screen

  @override
  void initState() {
    super.initState();
    print('inside state:');
    followingPageController.addListener(followingPageListener);
    forYouPageController.addListener(forYouPageListener);
    fetchNextFollowingItem();
    fetchNextForYouItem();
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
        print(nextItem);
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
      setState(() {
        forYouItems.add(item);

        currentPage++;
        isLoading = false;
        print(nextItem);
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

  Widget buildPageView() {
    if(tabIndex == 0) {
      return buildPageView1(followingPageController, followingItems.length);
    } else {
      return buildPageView2(forYouPageController, forYouItems.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildPageView(),
          buildPageViewButtons(),
        ],
      ),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget _buildLoaderIndicator() {
    return isLoading ? CircularProgressIndicator() : SizedBox.shrink();
  }

  Widget buildPageViewButtons() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  print("Following tapped.");
                  setState(() {
                    followingTextColor = selectedTextColor;
                    followingWeight = FontWeight.bold;
                    forYouTextColor = unselectedTextColor;
                    forYouWeight = FontWeight.normal;
                    selectedFeed = "Following";
                    tabIndex = 0;
                  });

                },
                child: Text('Following',
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: followingWeight,
                        color: followingTextColor)),
              ),
              SizedBox(
                width: 7,
              ),
              Container(
                color: Colors.transparent,
                height: 10,
                width: 1.0,
              ),
              SizedBox(
                width: 7,
              ),
              GestureDetector(
                onTap: (){
                  print("For You tapped.");
                  setState(() {
                    followingTextColor = unselectedTextColor;
                    followingWeight = FontWeight.normal;
                    forYouTextColor = selectedTextColor;
                    forYouWeight = FontWeight.bold;
                    selectedFeed = "For You";
                    tabIndex = 1;
                  });
                },
                child: Text('For You',
                    style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: forYouWeight,
                        color: forYouTextColor)),
              )
            ]),
      ),
    );
  }

  Widget buildPageView1(PageController controller, int itemCount) {
    return PageView.builder(
      controller: tabIndex == 0 ? followingPageController: forYouPageController,
      itemCount: tabIndex == 0 ? followingItems.length + 1: forYouItems.length + 1,
      onPageChanged: (index) {
        index = index;
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
          if (index < followingItems.length) {
            print("setting a following page");
            print(followingPageController.page);
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
      onPageChanged: (index) {
        index = index;
        print("onPageChanged index to $index");
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
          print("For you index is $index");
          if (index < forYouItems.length) {
            print("setting a forYou page");
            print(forYouPageController.page);
            return MCQFeed(
              content: forYouItems[index]
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

Widget buildFloatingActionButton() {
  return Padding(
    padding: EdgeInsets.only(bottom: 36.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildCustomFloatingActionButton('images/Ellipse21.png', 55, 55, ""),
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

class FlashCardFeed extends StatelessWidget {
  final Map<String, dynamic> content;

  const FlashCardFeed({
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    String mainTitle = "";
    if(content["type"] == "flashcard") {
      mainTitle = content["flashcard_front"];
    } else {
      mainTitle = content["question"];
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 73.0),
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
          Align(
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
          ),
        ],
      ),
    );
  }
}

class MCQFeed extends StatefulWidget {
  final Map<String, dynamic> content;

  MCQFeed({required this.content});

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

  Color defaultAnswerColor = const Color(0xFFFFFFFF).withOpacity(0.2);
  Color correctAnswerColor = Color(0xFF28B18F);
  Color incorrectAnswerColor = Color(0xFFDC5F5F);
  Color answerAColor = Color(0xFFFFFFFF).withOpacity(0.2);
  Color answerBColor = Color(0xFFFFFFFF).withOpacity(0.2);
  Color answerCColor = Color(0xFFFFFFFF).withOpacity(0.2);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> content = widget.content;

    String mainTitle = "";
    if (content["type"] == "flashcard") {
      mainTitle = content["flashcard_front"];
    } else {
      mainTitle = content["question"];
    }

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
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 150.0, left: 16.0, right: 73.0, bottom: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        mainTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print("answer a tapped");
                              setState(() {
                                print("inside set state");
                                // Change the color when pressed
                                // Set the new color value based on your requirement
                                answerAColor = answerAColor == incorrectAnswerColor ? defaultAnswerColor : incorrectAnswerColor;
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
                                answerBColor = answerBColor == correctAnswerColor ? defaultAnswerColor : correctAnswerColor;
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
                                // Change the color when pressed
                                // Set the new color value based on your requirement
                                answerCColor = answerCColor == correctAnswerColor ? defaultAnswerColor : correctAnswerColor;
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 6),
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
                            padding: const EdgeInsets.only(bottom: 24),
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
                  ],
                ),
              ),
            ),
          ),
          Align(
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
          ),
        ],
      ),
    );
  }
}

    class VideoItem extends StatelessWidget {
  final String videoUrl;
  final String username;
  final String caption;

  const VideoItem({
    required this.videoUrl,
    required this.username,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
          fit: StackFit.expand,
          children: [
            VideoPlayerWidget(videoUrl: videoUrl),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: Text(
                  username.substring(0, 1).toUpperCase(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
              title: Text(username),
              subtitle: Text(caption),
            ),
          ],
        ),
    );
  }
}


class VideoPlayerWidget extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.blue,
        child: Center(
          child: Text(
            'Video Player Placeholder',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
