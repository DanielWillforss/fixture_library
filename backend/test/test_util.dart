import 'dart:convert';

import 'package:lightsapp_backend/database/database.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class TestDatabaseConnection implements Database {
  static final TestDatabaseConnection instance = TestDatabaseConnection();

  Connection? _conn;

  @override
  Future<Result> execute(Object query, {Object? parameters}) async {
    try {
      final conn = await _getConnection();
      return await conn.execute(query, parameters: parameters);
    } catch (_) {
      _conn = null;
      final conn = await _getConnection();
      return await conn.execute(query, parameters: parameters);
    }
  }

  Future<void> close() async {
    await _conn?.close();
    _conn = null;
  }

  // Test lifecycle helpers
  Future<void> setUp() async {
    await execute('BEGIN');
  }

  Future<void> tearDown() async {
    await execute('ROLLBACK');
    await close();
  }

  Future<Connection> _getConnection() async {
    if (_conn == null || !_conn!.isOpen) {
      _conn = await _openConnection();
    }
    return _conn!;
  }

  Future<Connection> _openConnection() async {
    return Connection.open(
      Endpoint(
        host: 'localhost',
        port: 5432,
        database: 'test_db',
        username: 'admin',
        password: 'admin',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
  }
}

Future<Response> callRouter(
  Router router,
  String method,
  String path, {
  Object? body,
}) {
  return router.call(
    Request(
      method,
      Uri.parse('http://localhost$path'),
      body: body == null ? null : jsonEncode(body),
      headers: {'content-type': 'application/json'},
    ),
  );
}
