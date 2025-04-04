import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:show_app_frontend/config/api_config.dart';
import 'package:show_app_frontend/models/show.dart';

class ShowService {
  Future<List<Show>> getShows() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/shows'));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((show) => Show.fromJson(show)).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }

  Future<void> deleteShow(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/shows/$id'),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete show');
    }
  }
}