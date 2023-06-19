import 'package:flutter/cupertino.dart';

import '../model/data_model.dart';
import '../screens/flash_card.dart';
import '../screens/mcq_card.dart';
import '../views/data_controller.dart';
import 'loader_indicator.dart';

Widget buildPageView(DataController dataController, DataRepository dataRepository) {
  return IndexedStack(
    index: dataRepository.tabIndex,
    children: [
      buildFollowingPageView(dataController, dataRepository),
      buildForYouPageView(dataController, dataRepository),
    ],
  );
}

Widget buildFollowingPageView(DataController dataController, DataRepository dataRepository) {
  final PageController controller = dataController.followingPageController;
  final int itemCount = dataRepository.followingItems.length;
  final bool isLoading = dataRepository.isFollowingPageLoading;

  return PageView.builder(
    controller: controller,
    itemCount: itemCount + 1,
    onPageChanged: (pageIndex) {
      dataRepository.followingPageIndex = pageIndex;
    },
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      if (index < itemCount) {
        return FlashCardFeed(content: dataRepository.followingItems[index]);
      } else {
        return buildLoaderIndicator(isLoading);
      }
    },
  );
}

Widget buildForYouPageView(DataController dataController, DataRepository dataRepository) {
  final PageController controller = dataController.forYouPageController;
  final int itemCount = dataRepository.forYouItems.length;
  final bool isLoading = dataRepository.isForYouPageLoading;

  return PageView.builder(
    controller: controller,
    itemCount: itemCount + 1,
    onPageChanged: (pageIndex) {
      dataRepository.forYouPageIndex = pageIndex;
    },
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      if (index < itemCount) {
        return MCQFeed(
          content: dataRepository.forYouItems[index],
          answer: dataRepository.answers[index],
        );
      } else {
        return buildLoaderIndicator(isLoading);
      }
    },
  );
}
