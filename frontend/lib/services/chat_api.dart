import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<Map<String, dynamic>> sendMessage(String message) async {
    final url = Uri.parse('$baseUrl/chat/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"prompt": message}),
    );
    debugPrint('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('Response data: $data');
      return data;
    } else {
      debugPrint('Error: ${response.reasonPhrase}');
      throw Exception('Failed to load response');
    }
  }
}
