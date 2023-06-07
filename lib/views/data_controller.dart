import 'package:flutter/material.dart';
import '../model/data_model.dart';

class DataController {
  final PageController followingPageController = PageController(initialPage: 0);
  final PageController forYouPageController = PageController(initialPage: 0);
  final DataRepository dataRepository;

  DataController(this.dataRepository) {
    initPageListeners();
    initializeData();
  }

  void initializeData() {
    if (dataRepository.tabIndex == 0) {
      fetchNextFollowingItem();
    } else {
      fetchNextForYouItem();
    }
  }

  void initPageListeners() {
    print("Inside initPageListeners");
    followingPageController.addListener(() {
      pageListener(followingPageController, fetchNextFollowingItem);
    });

    forYouPageController.addListener(() {
      pageListener(forYouPageController, fetchNextForYouItem);
    });
  }

  void pageListener(PageController controller, Future<void> Function() fetchData) {
    print("Inside pageLister ${controller.page} ${dataRepository.followingItems.length}");
    if((dataRepository.tabIndex == 0 && controller.page == dataRepository.followingItems.length - 1) ||
        (dataRepository.tabIndex == 1 && controller.page == dataRepository.forYouItems.length - 1)) {
      print("condition met");
      if (!dataRepository.isLoading) {
        fetchData();
      }
    }
  }

  Future<void> fetchNextFollowingItem() async {
    fetchData(dataRepository.fetchNextFollowingItem);
  }

  Future<void> fetchNextForYouItem() async {
    fetchData(dataRepository.fetchNextForYouItem);
  }

  Future<void> fetchData(Future<void> Function() fetchDataMethod) async {
    dataRepository.isLoading = true;

    try {
      await fetchDataMethod();
    } catch (e) {
      // Handle error
      print('Error: $e');
    } finally {
      dataRepository.isLoading = false;
    }
  }

  void dispose() {
    followingPageController.dispose();
    forYouPageController.dispose();
  }
}
