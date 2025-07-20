import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http://127.0.0.1:8000'});

  Future<String> chat(String prompt) async {
    final res = await http.post(
      Uri.parse('$baseUrl/chat/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt ': prompt}),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['response'];
    } else {
      throw Exception('Failed to get chat response');
    }
  }

  Future<String> getTopic(String topic) async {
    final res = await http.get(Uri.parse('$baseUrl/info/$topic'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['description'];
    } else {
      throw Exception('Topic not found');
    }
  }

  Future<String> analyzeLog(String content) async {
    final res = await http.post(
      Uri.parse('$baseUrl/logs/'),
      headers: {'Content-Type': 'application/octet-stream'},
      body: content,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['analysis'];
    } else {
      throw Exception('Log analysis failed');
    }
  }
}
