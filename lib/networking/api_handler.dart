import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:brotli/brotli.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:http/http.dart' as http;

class APIHandler {
  // Sends a request to the specified URL asynchronously.
  // Decodes the response body based on the content-encoding type (gzip, br, or none).
  // Prints the decoded response body.
  Future<String> sendRequest(String url) async {
    http.Response response = await http.get(
      Uri.parse(url),
      headers: APIConstants.headers,
    );

    List<int> bytes = response.bodyBytes;
    String responseBody;
    if (response.headers['content-encoding'] == 'gzip') {
      responseBody = utf8.decode(GZipDecoder().decodeBytes(bytes));
    } else if (response.headers['content-encoding'] == 'br') {
      responseBody = utf8.decode(brotli.decode(bytes));
    } else {
      responseBody = utf8.decode(bytes);
    }

    return responseBody;
  }
}
