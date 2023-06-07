import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tiktokclone/utils/common.dart';

import '../model/data_model.dart';
import '../views/data_controller.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/floating_action_buttons.dart';
import '../widgets/gradient_background.dart';
import '../widgets/page_view.dart';
import '../widgets/song_bar.dart';
import '../widgets/top_bar.dart';

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
            child: buildPageView(dataController, dataRepository)
        ),
        buildSongBarWidget(playlist),
      ],
    );
  }

  void followingTapped() {
    setState(() {
      dataRepository.tabIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dataController.followingPageController.jumpToPage(0);
        // Manually set the page to 0
      });
      if(!dataRepository.isFollowingPageInitialized) {
        dataController.fetchNextFollowingItem();
      }
    });
  }

  void forYouTapped() {
    setState(() {
      dataRepository.tabIndex = 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dataController.forYouPageController.jumpToPage(0);
        // Manually set the page to 0
      });
      if(!dataRepository.isForYouPageInitialized) {
        dataController.fetchNextForYouItem();
      }
    });
  }
}