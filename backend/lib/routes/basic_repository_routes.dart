import 'dart:convert';

import 'package:lightsapp_backend/repositories/basic_base_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class CombinedBasicRepositoryRoutes {
  final FixtureTypeRepository typeRepo;
  final ManufacturerRepository manufacturerRepo;
  final PowerConnectorRepository connectorRepo;
  final ChannelContentRepository channelContentRepos;

  CombinedBasicRepositoryRoutes(
    this.typeRepo,
    this.manufacturerRepo,
    this.connectorRepo,
    this.channelContentRepos,
  );

  void register(Router router) {
    router.get('/basic/', _getAll);
  }

  Future<Response> _getAll(Request request) async {
    final results = await Future.wait([
      typeRepo.getAll(),
      manufacturerRepo.getAll(),
      connectorRepo.getAll(),
      channelContentRepos.getAll(),
    ]);

    final encoded = results
        .map(
          (result) =>
              result.map((key, value) => MapEntry(key.toString(), value)),
        )
        .toList();

    return Response.ok(
      jsonEncode(encoded),
      headers: {'content-type': 'application/json'},
    );
  }
}

class BasicRepositoryRoutes {
  final BasicBaseRepository repo;
  final String path;

  BasicRepositoryRoutes(this.repo, this.path);

  void register(Router router) {
    router.post('/basic/$path/', _create);
    router.put('/basic/$path/<id>/', _update);
    router.delete('/basic/$path/<id>/', _delete);
  }

  Future<Response> _create(Request request) async {
    final body = jsonDecode(await request.readAsString());

    final id = await repo.create(body['name']);

    return Response.ok(jsonEncode({'id': id}));
  }

  Future<Response> _update(Request request, String id) async {
    final body = jsonDecode(await request.readAsString());

    await repo.update(int.parse(id), body['name']);

    return Response.ok(jsonEncode({'success': true}));
  }

  Future<Response> _delete(Request request, String id) async {
    final affected = await repo.delete(int.parse(id));

    return Response.ok(jsonEncode({'deleted': affected}));
  }
}
