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
  Color followingTextColor = Colors.white70;
  Color forYouTextColor = Colors.white;
  FontWeight followingWeight = FontWeight.bold;
  FontWeight forYouWeight = FontWeight.normal;
  String selectedFeed = "Following";
  String nextItem = ''; // Initial next item value

  @override
  void initState() {
    super.initState();
    print('inside state:');
    fetchNextFollowingItem();
    fetchNextForYouItem();
  }

  Future<void> fetchNextFollowingItem() async {
    try {
      final item = await getNextFollowingItem();
      setState(() {
        nextItem = item;
        print(nextItem);
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> fetchNextForYouItem() async {
    try {
      final item = await getNextForYouItem();
      setState(() {
        nextItem = item;
        print(nextItem);
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: PageController(
              initialPage: 0,
              viewportFraction: 1,
            ),
            itemCount: 10,
            onPageChanged: (index) {
              index = index;
            },
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              index = index;
              return VideoFeed(
                videoUrl: 'https://example.com/video.mp4', // Replace with video URL
                username: '$selectedFeed User $index',
                caption: 'This is video $index',
              );
            },
          ),
          SafeArea(
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
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.favorite),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.comment),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.share),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.music_note),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.music_note),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black, // Set the background color to black
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Bookmarks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}



class VideoFeed extends StatelessWidget {
  final String videoUrl;
  final String username;
  final String caption;

  const VideoFeed({
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
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
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
