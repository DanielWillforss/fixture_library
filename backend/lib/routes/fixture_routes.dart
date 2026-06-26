import 'dart:convert';

import 'package:lightsapp_backend/repositories/fixture_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class FixtureRoutes {
  final FixtureRepository fixtureRepo;

  FixtureRoutes(this.fixtureRepo);

  void register(Router router) {
    router.get('/fixtures/', _getAll);

    router.post('/fixtures/', _create);

    router.put('/fixtures/<id>/', _update);

    router.delete('/fixtures/<id>/', _delete);
  }

  Future<Response> _getAll(Request request) async {
    final fixtures = await fixtureRepo.getAllFixtures();

    return Response.ok(
      jsonEncode(fixtures.map((e) => e.toJson()).toList()),
      headers: {'content-type': 'application/json'},
    );
  }

  Future<Response> _create(Request request) async {
    final body = jsonDecode(await request.readAsString());

    final id = await fixtureRepo.create(
      fixtureTypeId: body['fixture_type_id'],
      name: body['name'],
      manufacturerId: body['manufacturer_id'],
      powerUsageWatt: body['power_usage_watt'],
      powerConnectorId: body['power_connector_id'],
      hasPowerLink: body['has_power_link'],
    );

    return Response.ok(jsonEncode({'id': id}));
  }

  Future<Response> _update(Request request, String id) async {

    final body = jsonDecode(await request.readAsString());

    await fixtureRepo.update(
      id: int.parse(id),
      fixtureTypeId: body['fixture_type_id'],
      name: body['name'],
      manufacturerId: body['manufacturer_id'],
      powerUsageWatt: body['power_usage_watt'],
      powerConnectorId: body['power_connector_id'],
      hasPowerLink: body['has_power_link'],
    );

    return Response.ok(jsonEncode({'success': true}));
  }

  Future<Response> _delete(Request request, String id) async {
    final affected = await fixtureRepo.delete(int.parse(id));

    return Response.ok(jsonEncode({'deleted': affected}));
  }
}
