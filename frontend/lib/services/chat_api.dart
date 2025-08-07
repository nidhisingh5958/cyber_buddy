import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const Duration timeoutDuration = Duration(seconds: 30);

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final url = Uri.parse('$baseUrl/chat/');

      debugPrint('Sending request to: $url');
      debugPrint('Request body: ${jsonEncode({"prompt": message})}');

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode({"prompt": message}),
          )
          .timeout(timeoutDuration);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response headers: ${response.headers}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          debugPrint('Parsed response data: $data');

          // Check if the response has the expected structure
          if (data is Map<String, dynamic>) {
            return data;
          } else {
            throw Exception(
              'Invalid response format: Expected Map but got ${data.runtimeType}',
            );
          }
        } catch (e) {
          debugPrint('JSON parsing error: $e');
          throw Exception('Failed to parse response JSON: $e');
        }
      } else {
        // Enhanced error handling with response body
        String errorMessage =
            'HTTP ${response.statusCode}: ${response.reasonPhrase}';

        try {
          // Try to parse error response body
          final errorData = jsonDecode(response.body);
          if (errorData is Map && errorData.containsKey('detail')) {
            errorMessage += ' - ${errorData['detail']}';
          } else if (errorData is Map && errorData.containsKey('message')) {
            errorMessage += ' - ${errorData['message']}';
          }
        } catch (e) {
          // If we can't parse the error response, include the raw body
          if (response.body.isNotEmpty) {
            errorMessage += ' - ${response.body}';
          }
        }

        debugPrint('API Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } on SocketException catch (e) {
      debugPrint('Network error: $e');
      throw Exception(
        'Network error: Please check if the server is running on $baseUrl',
      );
    } on TimeoutException catch (e) {
      debugPrint('Timeout error: $e');
      throw Exception('Request timeout: Server took too long to respond');
    } on FormatException catch (e) {
      debugPrint('Format error: $e');
      throw Exception('Invalid response format from server');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // Method to test server connectivity
  Future<bool> testConnection() async {
    try {
      final url = Uri.parse('$baseUrl/');
      final response = await http.get(url).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Connection test failed: $e');
      return false;
    }
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ChatService {
//   static const String baseUrl = 'http://127.0.0.1:8000';

//   Future<Map<String, dynamic>> sendMessage(String message) async {
//     final url = Uri.parse('$baseUrl/chat/');
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"prompt": message}),
//     );
//     debugPrint('Response status: ${response.statusCode}');

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       debugPrint('Response data: ${data['response']}');
//       return data;
//     } else {
//       debugPrint('Error: ${response.reasonPhrase}');
//       throw Exception('Failed to load response');
//     }
//   }
// }
