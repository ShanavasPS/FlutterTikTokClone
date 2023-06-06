import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchData(String url) async {
  final response = await http.get(Uri.parse(url));
  print('Inside fetchData:');
  if (response.statusCode == 200) {
    print("Received positive response");
    print(response.body);
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<Map<String, dynamic>> getNextFollowingItem() async {
  return fetchData('https://cross-platform.rp.devfactory.com/following');
}

Future<Map<String, dynamic>> getNextForYouItem() async {
  return fetchData('https://cross-platform.rp.devfactory.com/for_you');
}

Future<Map<String, dynamic>> revealAnswer(int mcqID) async {
  return fetchData('https://cross-platform.rp.devfactory.com/reveal?id=$mcqID');
}
