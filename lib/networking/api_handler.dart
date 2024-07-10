import 'package:http/http.dart' as http;

class APIHandler {
  Future<String> sendRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36"
    });

    return response.body;
  }
}
