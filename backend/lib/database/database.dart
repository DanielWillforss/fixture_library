import 'package:postgres/postgres.dart';

abstract class Database {
  Future<Result> execute(Object query, {Object? parameters});
}
