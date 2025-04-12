import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stop_data.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';
  
  Future<StopData> fetchStopData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/stop'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return StopData.fromJson(jsonData);
      } else {
        throw Exception('Failed to load stop data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load stop data: $e');
    }
  }
}