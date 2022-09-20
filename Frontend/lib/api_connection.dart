import 'dart:async';

import 'package:http/http.dart' as http;

/// Provides methods to the rest of the application for calling the backend APIs
class ApiConnection {
  final http.Client client = http.Client();
  static String baseUrl = (const String.fromEnvironment('BACKEND_URL')).length != 0 ? const String.fromEnvironment('BACKEND_URL') : "http://localhost:5000/";

  /// Enter a new batch of teams into the system
  static Future<void> shortenUrl(String url, Function(String, int) callback) async {
    var request = http.Request('GET', Uri.parse('$baseUrl/shorten?url=$url'));
    sendRequest(request, callback);
  }

  /// enter match results into the system
  static Future<void> retrieveUrl(String base62code, Function(String, int) callback) async {
    var request = http.Request('GET', Uri.parse('$baseUrl/retrieve?base62code=$base62code'));
    sendRequest(request, callback);
  }

  /// Abstract out code that will be sent for every request
  static Future<void> sendRequest(var request, Function(String, int) callback) async {
    try {
      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 10));
      callback(await response.stream.bytesToString(), response.statusCode);
    } on TimeoutException catch (e) {
      callback("Request timed out", 400);
    }
  }
}
