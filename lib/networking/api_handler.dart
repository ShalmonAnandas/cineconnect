import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class APIHandler {
  static const platform = MethodChannel('com.example.cineconnect/api');

  Future<String> makeGetRequest({String? url}) async {
    try {
      final String result = await platform.invokeMethod('makeGetRequest', {
        'url': url,
        'headers': {
          "accept": "application/json",
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4N2Q1NTg1YTU0OTdiMzczNjc5ZThiZGM3ZDZmMGQyMiIsIm5iZiI6MTcyNzI3NDY4Ni4xMzE3MTUsInN1YiI6IjYyMWRlNjY2ZDM4YjU4MDAxYmY0NDM3NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.IAlPpb4-K1Y5aoZvBfw92J-Air_fNS0U2EcNCrYwKFY"
        }
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to make API call: '${e.message}'.");
      return "";
    }
  }

  Future<String?> postRequest({String? url, String? body}) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(url!));
    request.body = body!;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String? responseString;
    if (response.statusCode == 200) {
      responseString = await response.stream.bytesToString();
    } else {
      responseString = response.reasonPhrase;
    }

    return responseString;
  }
}
