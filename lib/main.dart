import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tiktokclone/providers/data_provider.dart';
import 'package:tiktokclone/providers/duration_provider.dart';
import 'package:tiktokclone/screens/home_page.dart';
import 'package:tiktokclone/utils/tiktok_colors.dart';
import 'package:tiktokclone/utils/tiktok_strings.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DataProvider()),
          ChangeNotifierProvider(create: (_) => DurationProvider())
        ],
        child: const TikTokApp(),
      ),
  );
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to black
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: TikTokColors.statusBar,
    ));
    return MaterialApp(
      title: TikTokStrings.appName,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}