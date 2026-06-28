import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lights_app/main.dart';

class BasicApi {
  static const String baseUrl = '${GlobalConstants.baseUrl}/basic';

  static Future<List<Map<int, String>>> getAllBasic() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load basics');
    }
    final List data = jsonDecode(response.body);
    return data.map((item) {
      final Map<String, dynamic> map = item;
      return map.map((key, value) => MapEntry(int.parse(key), value as String));
    }).toList();
  }

  static final pageToPath = [
    'fixture-types',
    'manufacturers',
    'power-connectors',
    'channel-content',
  ];

  static Future<void> createBasic(String name, int page) async {
    final subpath = pageToPath[page];
    await _create(name, '$baseUrl/$subpath/');
  }

  static Future<void> _create(String name, String path) async {
    final response = await http.post(
      Uri.parse(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create fixture');
    }
  }

  static Future<void> updateBasic(int id, String name, int page) async {
    final subpath = pageToPath[page];
    await _update(name, '$baseUrl/$subpath/$id/');
  }

  static Future<void> _update(String name, String path) async {
    final response = await http.put(
      Uri.parse(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update fixture');
    }
  }

  static Future<void> deleteBasic(int id, int page) async {
    final subpath = pageToPath[page];
    await _delete('$baseUrl/$subpath/$id/');
  }

  /// DELETE /fixtures/models/{id}
  static Future<void> _delete(String path) async {
    final response = await http.delete(Uri.parse(path));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete fixture');
    }
  }
}
