import 'package:lightsapp_backend/repositories/basic_base_repository.dart';
import 'package:lightsapp_backend/repositories/mode_repository.dart';
import 'package:lightsapp_backend/repositories/fixture_repository.dart';
import 'package:lightsapp_backend/repositories/channel_repository.dart';
import 'package:lightsapp_backend/routes/basic_repository_routes.dart';
import 'package:lightsapp_backend/routes/mode_routes.dart';
import 'package:lightsapp_backend/routes/fixture_routes.dart';
import 'package:lightsapp_backend/routes/channel_routes.dart';
import 'package:shelf_router/shelf_router.dart';

class RouteBuilder {
  Router build() {
    final router = Router();

    FixtureRoutes(FixtureRepository()).register(router);

    ModeRoutes(ModeRepository()).register(router);

    ChannelRoutes(ChannelRepository()).register(router);

    final fixtureRepo = FixtureTypeRepository();
    final manufacturerRepo = ManufacturerRepository();
    final connectorRepo = PowerConnectorRepository();
    final contentRepo = ChannelContentRepository();

    BasicRepositoryRoutes(fixtureRepo, 'fixture-types').register(router);

    BasicRepositoryRoutes(manufacturerRepo, 'manufacturers').register(router);

    BasicRepositoryRoutes(connectorRepo, 'power-connectors').register(router);

    BasicRepositoryRoutes(contentRepo, 'channel-content').register(router);

    CombinedBasicRepositoryRoutes(
      fixtureRepo,
      manufacturerRepo,
      connectorRepo,
      contentRepo,
    ).register(router);

    return router;
  }
}
