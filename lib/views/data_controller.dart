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
      fetchNextFollowingItem();
      fetchNextForYouItem();
  }

  void initPageListeners() {
    followingPageController.addListener(() {
      pageListener(followingPageController, fetchNextFollowingItem);
    });

    forYouPageController.addListener(() {
      pageListener(forYouPageController, fetchNextForYouItem);
    });
  }

  void pageListener(PageController controller, Future<void> Function() fetchData) {
    final double currentPage = controller.page ?? 0;
    final int itemCount = dataRepository.itemCount();
    if (currentPage >= itemCount - 1 && !dataRepository.isLoading()) {
      fetchData();
    }
  }

  Future<void> fetchNextFollowingItem() async {
    fetchData(dataRepository.fetchNextFollowingItem);
  }

  Future<void> fetchNextForYouItem() async {
    fetchData(dataRepository.fetchNextForYouItem);
  }

  Future<void> fetchData(Future<void> Function() fetchDataMethod) async {
    try {
      await fetchDataMethod();
    } catch (e) {
      // Handle error
    } finally {
    }
  }

  void dispose() {
    followingPageController.dispose();
    forYouPageController.dispose();
  }
}
