import 'dart:convert';

import 'package:lightsapp_backend/repositories/channel_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ChannelRoutes {
  final ChannelRepository repo;

  ChannelRoutes(this.repo);

  void register(Router router) {
    router.post('/channels/', _create);
    router.put('/channels/<id>/', _update);
    router.delete('/channels/<id>/', _delete);
  }

  Future<Response> _create(Request request) async {
    final body = jsonDecode(await request.readAsString());

    final id = await repo.createChannel(
      body['mode_id'],
      body['channel_number'],
      body['channel_content_id'],
    );

    return Response.ok(jsonEncode({'id': id}));
  }

  Future<Response> _update(Request request, String id) async {
    final body = jsonDecode(await request.readAsString());

    await repo.updateChannel(
      int.parse(id),
      body['channel_number'],
      body['channel_content_id'],
    );

    return Response.ok(jsonEncode({'success': true}));
  }

  Future<Response> _delete(Request request, String id) async {
    await repo.deletechannel(int.parse(id));

    return Response.ok(jsonEncode({'success': true}));
  }
}
