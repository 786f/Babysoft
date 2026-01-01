import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://dev-villamanager.skills201.com/VM/mobile-api/';

  static String? token;

  static Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: headers,
      body: body,
    );

    print('==============================');
    print('URL: $endpoint');
    print('HEADERS: $headers');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');
    print('==============================');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  }
}
