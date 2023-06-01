import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.black,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: 'Tab 1'),
                    Tab(text: 'Tab 2'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Contents of Tab 1
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: PageView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, int index) {
                                    return VideoFeed(
                                      videoUrl: 'https://example.com/video.mp4', // Replace with video URL
                                      username: 'User $index',
                                      caption: 'This is video $index',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Contents of Tab 2
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: PageView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, int index) {
                                    return VideoFeed(
                                      videoUrl: 'https://example.com/video.mp4', // Replace with video URL
                                      username: 'User $index',
                                      caption: 'This is video $index',
                                    );
                                  },
                                ),
                              ),
                            ],
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
