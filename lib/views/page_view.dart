import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';
import '../screens/flash_card.dart';
import '../screens/mcq_card.dart';
import '../views/loader_indicator.dart';

class PageViews extends StatelessWidget {
  const PageViews({super.key});

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: context.watch<DataProvider>().tabIndex,
      children: const [
        FollowingPageView(),
        ForYouPageView(),
      ],
    );
  }
}

class FollowingPageView extends StatelessWidget {
  const FollowingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = context.watch<DataProvider>().followingPageController;
    final int itemCount = context.watch<DataProvider>().followingItems.length;
    return PageView.builder(
      controller: controller,
      itemCount: itemCount + 1,
      onPageChanged: (pageIndex) {
        context.read<DataProvider>().followingPageIndex = pageIndex;
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        if (index < itemCount) {
          context.read<DataProvider>().followingPageItemIndex = index;
          return const FlashCardFeed();
        } else {
          return const LoaderIndicator();
        }
      },
    );
  }
}

class ForYouPageView extends StatelessWidget {
  const ForYouPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = context.watch<DataProvider>().forYouPageController;
    final int itemCount = context.watch<DataProvider>().forYouItems.length;

    return PageView.builder(
      controller: controller,
      itemCount: itemCount + 1,
      onPageChanged: (pageIndex) {
        context.read<DataProvider>().forYouPageIndex = pageIndex;
      },
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        if (index < itemCount) {
          context.read<DataProvider>().forYouPageItemIndex = index;
          return const MCQFeed();
        } else {
          return const LoaderIndicator();
        }
      },
    );
  }
}