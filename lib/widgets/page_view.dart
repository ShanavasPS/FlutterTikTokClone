import 'package:flutter/cupertino.dart';

import '../model/data_model.dart';
import '../screens/flash_card.dart';
import '../screens/mcq_card.dart';
import '../views/data_controller.dart';
import 'loader_indicator.dart';

Widget buildPageView(DataController dataController, DataRepository dataRepository) {
  final PageController followingController = dataController.followingPageController;
  final PageController forYouController = dataController.forYouPageController;
  final int followingItemCount = dataRepository.followingItems.length;
  final int forYouItemCount = dataRepository.forYouItems.length;
  final bool isFollowingLoading = dataRepository.isFollowingPageLoading;
  final bool isForYouLoading = dataRepository.isForYouPageLoading;

  return IndexedStack(
    index: dataRepository.tabIndex,
    children: [
      PageView.builder(
        controller: followingController,
        itemCount: followingItemCount + 1,
        onPageChanged: (pageIndex) {
          dataRepository.followingPageIndex = pageIndex;
        },
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index < followingItemCount) {
            return FlashCardFeed(content: dataRepository.followingItems[index]);
          } else {
            return buildLoaderIndicator(isFollowingLoading);
          }
        },
      ),
      PageView.builder(
        controller: forYouController,
        itemCount: forYouItemCount + 1,
        onPageChanged: (pageIndex) {
          dataRepository.forYouPageIndex = pageIndex;
        },
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index < forYouItemCount) {
            return MCQFeed(
              content: dataRepository.forYouItems[index],
              answer: dataRepository.answers[index],
            );
          } else {
            return buildLoaderIndicator(isForYouLoading);
          }
        },
      ),
    ],
  );
}
