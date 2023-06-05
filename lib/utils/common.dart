import 'package:flutter/material.dart';

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