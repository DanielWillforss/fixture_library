import 'dart:convert';

import 'package:shelf/shelf.dart';

Response jsonResponse(Object body) {
  return Response.ok(
    jsonEncode(body),
    headers: {'Content-Type': 'application/json'},
  );
}
