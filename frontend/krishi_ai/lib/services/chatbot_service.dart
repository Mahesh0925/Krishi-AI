import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  static const String _baseUrl = 'https://mor-backend-4i9u.onrender.com';
  static const String _chatbotEndpoint = '/chatbot';

  /// Send a message to the chatbot and get a response
  ///
  /// [message] - The user's message
  /// [history] - Optional conversation history
  ///
  /// Returns the bot's reply as a String
  static Future<String> chatWithBot(
    String message, {
    List<Map<String, String>>? history,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_chatbotEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message, 'history': history ?? []}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? 'Sorry, I could not process your request.';
      } else {
        return 'Error: Unable to connect to the server. Please try again later.';
      }
    } catch (e) {
      return 'Error: Failed to get response. Please check your internet connection.';
    }
  }
}
