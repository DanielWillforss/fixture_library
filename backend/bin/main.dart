import 'package:lightsapp_backend/routes/route_builder.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<void> main() async {
  final router = RouteBuilder().build();

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  final server = await io.serve(handler, '127.0.0.1', 8080);
  print('Server running on http://${server.address.host}:${server.port}');
}
