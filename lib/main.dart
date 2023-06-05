import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tittokclone/screens/home_page.dart';

void main() {
  runApp(TikTokApp());
}

class TikTokApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set the status bar color to black
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    return MaterialApp(
      title: 'TikTok',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}