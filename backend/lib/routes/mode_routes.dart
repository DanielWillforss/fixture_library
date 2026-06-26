import 'dart:convert';

import 'package:lightsapp_backend/repositories/mode_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ModeRoutes {
  final ModeRepository repo;

  ModeRoutes(this.repo);

  void register(Router router) {
    router.post('/modes/', _create);
    router.put('/modes/<id>/', _update);
    router.delete('/modes/<id>/', _delete);
  }

  Future<Response> _create(Request request) async {
    final body = jsonDecode(await request.readAsString());

    final id = await repo.createMode(
      body['fixture_id'],
      body['name'],
      body['channel_count'],
    );

    return Response.ok(jsonEncode({'id': id}));
  }

  Future<Response> _update(Request request, String id) async {
    final body = jsonDecode(await request.readAsString());

    await repo.updateMode(int.parse(id), body['name'], body['channel_count']);

    return Response.ok(jsonEncode({'success': true}));
  }

  Future<Response> _delete(Request request, String id) async {
    await repo.deleteMode(int.parse(id));

    return Response.ok(jsonEncode({'success': true}));
  }
}
