import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../utils/common.dart';

class DurationProvider with ChangeNotifier, WidgetsBindingObserver {
  late String actualTimeSpent = "";
  late Timer _timer;
  DateTime _sessionStartTime = DateTime.now();
  Duration _totalSessionDuration = Duration.zero;
  AppLifecycleState _lastLifecycleState = AppLifecycleState.resumed;

  DurationProvider() {
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_lastLifecycleState == AppLifecycleState.resumed) {
        _totalSessionDuration = DateTime.now().difference(_sessionStartTime);
        actualTimeSpent = getDuration(_totalSessionDuration);
        notifyListeners();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _sessionStartTime = DateTime.now();
    } else if (state == AppLifecycleState.paused) {
      _totalSessionDuration += DateTime.now().difference(_sessionStartTime);
      notifyListeners();
    }
    _lastLifecycleState = state;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }
}
