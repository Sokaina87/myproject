import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:show_app_frontend/config/api_config.dart';
import 'package:show_app_frontend/models/show.dart';

class ApiService {
  static Future<List<Show>> getShows() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/shows'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((show) => Show.fromJson(show)).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }

  static Future<Show> addShow(
    String title,
    String description,
    String category,
    File? imageFile,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse('${ApiConfig.baseUrl}/shows'));
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['category'] = category;
    
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    var response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return Show.fromJson(json.decode(responseData));
    } else {
      throw Exception('Failed to add show');
    }
  }

  static Future<Show> updateShow(
    int id,
    String title,
    String description,
    String category,
    File? imageFile,
  ) async {
    var request = http.MultipartRequest('PUT', Uri.parse('${ApiConfig.baseUrl}/shows/$id'));
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['category'] = category;
    
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    var response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return Show.fromJson(json.decode(responseData));
    } else {
      throw Exception('Failed to update show');
    }
  }

  static Future<void> deleteShow(int id) async {
    final response = await http.delete(Uri.parse('${ApiConfig.baseUrl}/shows/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete show');
    }
  }
}