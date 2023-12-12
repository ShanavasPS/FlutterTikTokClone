import 'package:flutter/material.dart';

import '../views/bottom_navigation_bar.dart';
import '../views/floating_action_buttons.dart';
import '../views/gradient_background.dart';
import '../views/page_view.dart';
import '../views/song_bar.dart';
import '../views/top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            gradientBackground(),
            const Foreground(),
          ]
      ),
      floatingActionButton: const FloatingActionButtons(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class Foreground extends StatelessWidget {
  const Foreground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TopBar(),
        Expanded(
          child: PageViews(),
        ),
        SongBar(),
      ],
    );
  }
}