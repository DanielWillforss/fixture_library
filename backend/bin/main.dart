import 'package:app_core/database/database.dart';
import 'package:lightsapp_backend/routes/route_builder.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<void> main(List<String> args) async {
  final port = args.isNotEmpty ? int.parse(args[0]) : 6000;

  Database.init(
    Endpoint(
      host: 'localhost',
      port: 5432,
      database: 'stage_control',
      username: 'admin',
      password: 'admin',
    ),
  );

  final router = RouteBuilder().build();

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  //final server = await io.serve(handler, '127.0.0.1', 6000);
  final server = await io.serve(handler, '127.0.0.1', port);
  print('Server running on http://${server.address.host}:${server.port}');
}
