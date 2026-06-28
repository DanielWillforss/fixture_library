import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lights_app/main.dart';
import 'package:lights_app/models/fixture_model.dart';

class FixturesApi {
  static const String baseUrl = GlobalConstants.baseUrl;

  static Future<List<Fixture>> getAllFixtures() async {
    print('$baseUrl/fixtures/');
    final response = await http.get(Uri.parse('$baseUrl/fixtures/'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load fixtures');
    }

    final List data = jsonDecode(response.body);
    final r = data.map((e) => Fixture.fromMap(e)).toList();
    return r;
  }

  /// POST /fixtures/models
  static Future<void> createFixture({
    required int fixtureTypeId,
    required String name,
    required int manufacturerId,
    required int powerUsageWatt,
    required int powerConnectorId,
    required bool hasPowerLink,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/fixtures/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fixture_type_id': fixtureTypeId,
        'name': name,
        'manufacturer_id': manufacturerId,
        'power_usage_watt': powerUsageWatt,
        'power_connector_id': powerConnectorId,
        'has_power_link': hasPowerLink,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create fixture');
    }
  }

  static Future<void> updateFixture({
    required int id,
    required int fixtureTypeId,
    required String name,
    required int manufacturerId,
    required int powerUsageWatt,
    required int powerConnectorId,
    required bool hasPowerLink,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/fixtures/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fixture_type_id': fixtureTypeId,
        'name': name,
        'manufacturer_id': manufacturerId,
        'power_usage_watt': powerUsageWatt,
        'power_connector_id': powerConnectorId,
        'has_power_link': hasPowerLink,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update fixture');
    }
  }

  static Future<void> deleteFixture({required int id}) async {
    final response = await http.delete(Uri.parse('$baseUrl/fixtures/$id/'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete fixture');
    }
  }

  static Future<void> createMode({
    required int fixtureId,
    required String name,
    required int channelCount,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/modes/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fixture_id': fixtureId,
        'name': name,
        'channel_count': channelCount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create mode');
    }
  }

  static Future<void> updateMode({
    required int id,
    required String name,
    required int channelCount,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/modes/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'channel_count': channelCount}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update mode');
    }
  }

  static Future<void> deleteMode({required int id}) async {
    final response = await http.delete(Uri.parse('$baseUrl/modes/$id/'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete mode');
    }
  }

  static Future<void> createChannel({
    required int modeId,
    required int channelNumber,
    required int channelContentId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/channels/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mode_id': modeId,
        'channel_number': channelNumber,
        'channel_content_id': channelContentId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create channel');
    }
  }

  static Future<void> updateChannel({
    required int id,
    required int channelNumber,
    required int channelContentId,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/channels/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'channel_number': channelNumber,
        'channel_content_id': channelContentId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update channel');
    }
  }

  static Future<void> deleteChannel({required int id}) async {
    final response = await http.delete(Uri.parse('$baseUrl/channels/$id/'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete channel');
    }
  }
}
