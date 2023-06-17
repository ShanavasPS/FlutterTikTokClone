import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData(String url, http.Client client) async {
  final response = await client.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<Map<String, dynamic>> getNextFollowingItem(http.Client client) async {
  return fetchData('https://cross-platform.rp.devfactory.com/following', client);
}

Future<Map<String, dynamic>> getNextForYouItem(http.Client client) async {
  return fetchData('https://cross-platform.rp.devfactory.com/for_you', client);
}

Future<Map<String, dynamic>> revealAnswer(int mcqID, http.Client client) async {
  return fetchData('https://cross-platform.rp.devfactory.com/reveal?id=$mcqID', client);
}
