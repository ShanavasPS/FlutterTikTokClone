import 'package:http/http.dart' as http;

Future<String> getNextFollowingItem() async {
  final response = await http.get(Uri.parse('https://cross-platform.rp.devfactory.com/following'));
  print('inside getNextFollowingItem:');
  if (response.statusCode == 200) {
    // Parse the response body and extract the next item
    //final nextItem = // extract the next item from the response body
    print("received positive response");
    print(response.body);
    return "Fetched next Following";
  } else {
    throw Exception('Failed to fetch next item');
  }
}

Future<String> getNextForYouItem() async {
  final response = await http.get(Uri.parse('https://cross-platform.rp.devfactory.com/for_you'));
  print('inside getNextForYouItem:');
  if (response.statusCode == 200) {
    // Parse the response body and extract the next item
    //final nextItem = // extract the next item from the response body
    print("received positive response");
    print(response.body);
    return "Fetched next For You";
  } else {
    throw Exception('Failed to fetch next item');
  }
}

Future<String> revealAnswer() async {
  final response = await http.get(Uri.parse('https://cross-platform.rp.devfactory.com/reveal?id=X'));
  print('inside getNextForYouItem:');
  if (response.statusCode == 200) {
    // Parse the response body and extract the next item
    //final nextItem = // extract the next item from the response body
    print("received positive response");
    print(response.body);
    return "Shanavas";
  } else {
    throw Exception('Failed to fetch next item');
  }
}
