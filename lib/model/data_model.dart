import 'package:tiktokclone/network/network_calls.dart';

class DataRepository {

  List<Map<String, dynamic>> followingItems = [];
  List<Map<String, dynamic>> forYouItems = [];
  List<Map<String, dynamic>> answers = [];

  Future<void> fetchNextFollowingItem() async {
    try {
      final item = await getNextFollowingItem();
      followingItems.add(item);
      print("received the below item");
      print(followingItems[0]);
      print(followingItems.length);
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> fetchNextForYouItem() async {
    try {
      final item = await getNextForYouItem();
      final answer = await revealAnswer(item["id"]);
      forYouItems.add(item);
      answers.add(answer);
      print("received the below item");
      print(forYouItems[0]);
      print(forYouItems.length);
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
}
