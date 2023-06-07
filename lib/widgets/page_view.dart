import 'package:flutter/cupertino.dart';

import '../model/data_model.dart';
import '../screens/flash_card.dart';
import '../screens/mcq_card.dart';
import '../views/data_controller.dart';
import 'loader_indicator.dart';

Widget buildPageView(DataController dataController, DataRepository dataRepository) {
  final PageController controller = dataRepository.tabIndex == 0
      ? dataController.followingPageController
      : dataController.forYouPageController;
  final int itemCount = dataRepository.tabIndex == 0
      ? dataRepository.followingItems.length
      : dataRepository.forYouItems.length;
  final bool isLoading = dataRepository.tabIndex == 0
      ? dataRepository.isFollowingPageLoading
      : dataRepository.isForYouPageLoading;

  return PageView.builder(
    controller: controller,
    itemCount: itemCount + 1,
    onPageChanged: (pageIndex) {
      if (dataRepository.tabIndex == 0) {
        dataRepository.followingPageIndex = pageIndex;
      } else {
        dataRepository.forYouPageIndex = pageIndex;
      }
    },
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      if (index < itemCount) {
        if (dataRepository.tabIndex == 0) {
          return FlashCardFeed(content: dataRepository.followingItems[index]);
        } else {
          return MCQFeed(
            content: dataRepository.forYouItems[index],
            answer: dataRepository.answers[index],
          );
        }
      } else {
        return buildLoaderIndicator(isLoading);
      }
    },
  );
}