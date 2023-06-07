import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tiktokclone/utils/common.dart';

import '../model/data_model.dart';
import '../views/data_controller.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../views/floating_action_buttons.dart';
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

  AppLifecycleState _lastLifecycleState = AppLifecycleState.resumed;

  DateTime _sessionStartTime = DateTime.now();

  Duration _totalSessionDuration = Duration.zero;

  String actualTimeSpent =  "";

  late Timer _timer;

  DataRepository dataRepository = DataRepository();
  late DataController dataController;

  @override
  void initState() {
    super.initState();
    print('inside state:');

    dataController = DataController(dataRepository);

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

  @override
  Widget build(BuildContext context) {
    print("Inside build of main");
    final List<dynamic> avatarAndPlaylist = dataRepository.updateAvatarAndPlaylist();
    String avatar = avatarAndPlaylist[0];
    String playlist = avatarAndPlaylist[1];

    return Scaffold(
      body: Stack(
          children: [
            gradientBackground(),
            buildForeground(playlist),
          ]
      ),
      floatingActionButton: buildFloatingActionButtons(avatar, dataRepository.tabIndex),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildForeground(String playlist) {
    return Column(
      children: [
        buildTopBar(dataRepository.tabIndex, actualTimeSpent, followingTapped, forYouTapped),
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
      dataRepository.tabIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dataController.followingPageController.jumpToPage(dataRepository.followingPageIndex);
        // Manually set the page to 0
      });
      if(!dataRepository.isFollowingPageInitialized) {
        dataController.fetchNextFollowingItem();
      }
    });
  }

  void forYouTapped() {
    print("For You tapped.");
    setState(() {
      dataRepository.tabIndex = 1;
      print("for you page index is ${dataRepository.forYouPageIndex}");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dataController.forYouPageController.jumpToPage(dataRepository.forYouPageIndex);
        // Manually set the page to 0
      });
      if(!dataRepository.isForYouPageInitialized) {
        dataController.fetchNextForYouItem();
      }
    });
  }

  Widget buildPageView() {
    print("inside buildPageView");
    final PageController controller = dataRepository.tabIndex == 0
        ? dataController.followingPageController
        : dataController.forYouPageController;
    final int itemCount = dataRepository.tabIndex == 0
        ? dataRepository.followingItems.length
        : dataRepository.forYouItems.length;

    return PageView.builder(
      controller: controller,
      itemCount: itemCount + 1,
      onPageChanged: (pageIndex) {
        print("Inside onPageChanged");
        if (dataRepository.tabIndex == 0) {
          dataRepository.followingPageIndex = pageIndex;
        } else {
          dataRepository.forYouPageIndex = pageIndex;
        }
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        print("Index inside itemBuilder is $index");
        if (index < itemCount) {
          if (dataRepository.tabIndex == 0) {
            return FlashCardFeed(content: dataRepository.followingItems[index]);
          } else {
            print("setting a forYou page");
            print(controller.page);
            return MCQFeed(
              content: dataRepository.forYouItems[index],
              answer: dataRepository.answers[index],
            );
          }
        } else {
          return buildLoaderIndicator(dataRepository.isLoading);
        }
      },
    );
  }
}