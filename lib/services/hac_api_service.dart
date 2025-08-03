import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HacApiService {
  final String baseUrl = 'https://friscoisdhacapi.vercel.app';

  Future<Map<String, dynamic>> _fetchData(
      String endpoint, String username, String password,
      {Map<String, dynamic>? extraParams}) async {
    final encodedUsername = Uri.encodeComponent(username);
    final encodedPassword = Uri.encodeComponent(password);

    String url = '$baseUrl$endpoint?username=$encodedUsername&password=$encodedPassword';

    if (extraParams != null) {
      extraParams.forEach((key, value) {
        url += '&$key=${Uri.encodeComponent(value.toString())}';
      });
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from $endpoint: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getStudentInfo(
      String username, String password) async {
    return _fetchData('/api/info', username, password);
  }

  Future<Map<String, dynamic>> getStudentGpa(
      String username, String password) async {
    return _fetchData('/api/gpa', username, password);
  }

  Future<Map<String, dynamic>> getStudentSchedule(
      String username, String password) async {
    return _fetchData('/api/schedule', username, password);
  }

  Future<Map<String, dynamic>> getCurrentClasses(
      String username, String password) async {
    return _fetchData('/api/currentclasses', username, password);
  }

  Future<Map<String, dynamic>> getPastClasses(
      String username, String password, int quarter) async {
    return _fetchData('/api/pastclasses', username, password,
        extraParams: {'quarter': quarter});
  }

  Future<Map<String, dynamic>> getTranscript(
      String username, String password) async {
    return _fetchData('/api/transcript', username, password);
  }
}