import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getNextFollowingItem() async {
  final response = await http.get(Uri.parse('https://cross-platform.rp.devfactory.com/following'));
  print('inside getNextFollowingItem:');
  if (response.statusCode == 200) {
    // Parse the response body and extract the next item
    //final nextItem = // extract the next item from the response body
    print("received positive response");
    print(response.body);
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch next item');
  }
}

Future<Map<String, dynamic>> getNextForYouItem() async {
  final response = await http.get(Uri.parse('https://cross-platform.rp.devfactory.com/for_you'));
  print('inside getNextForYouItem:');
  if (response.statusCode == 200) {
    // Parse the response body and extract the next item
    //final nextItem = // extract the next item from the response body
    print("received positive response");
    print(response.body);
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch next item');
  }
}

Future<Map<String, dynamic>> revealAnswer(int mcqID) async {
  final response = await http.get(Uri.parse('https://cross-platform.rp.devfactory.com/reveal?id=$mcqID'));
  print('inside revealAnswer:');
  if (response.statusCode == 200) {
    // Parse the response body and extract the next item
    //final nextItem = // extract the next item from the response body
    print("received positive response");
    print(response.body);
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch next item');
  }
}
