// lib/repositories/base_repository.dart

import 'package:lightsapp_backend/database/database.dart';
import 'package:lightsapp_backend/database/database_connection.dart';
import 'package:postgres/postgres.dart';

class FixtureTypeRepository extends BasicBaseRepository {
  FixtureTypeRepository({super.db})
    : super(table: 'fixture_type', schema: 'fixture_library');
}

class ManufacturerRepository extends BasicBaseRepository {
  ManufacturerRepository({super.db})
    : super(table: 'manufacturer', schema: 'fixture_library');
}

class PowerConnectorRepository extends BasicBaseRepository {
  PowerConnectorRepository({super.db})
    : super(table: 'power_connector', schema: 'fixture_library');
}

class ChannelContentRepository extends BasicBaseRepository {
  ChannelContentRepository({super.db})
    : super(table: 'channel_content', schema: 'fixture_library');
}

abstract class BasicBaseRepository {
  final String table;
  final String schema;
  final Database db;

  BasicBaseRepository({required this.table, required this.schema, Database? db})
    : db = db ?? DatabaseConnection();

  Future<Map<int, String>> getAll() async {
    final result = await db.execute(
      //Sql.named('SELECT * FROM fixture_library.fixture_type ORDER BY id'),
      Sql.named('SELECT * FROM $schema.$table ORDER BY id'),
    );

    return Map.fromEntries(
      result
          .map((row) => row.toColumnMap())
          .map((row) => MapEntry(row['id'] as int, row['name'] as String)),
    );
  }

  Future<int> create(String name) async {
    final result = await db.execute(
      Sql.named('''
        INSERT INTO $schema.$table(name)
        VALUES (@name)
        RETURNING id
        '''),
      parameters: {'name': name},
    );

    return result.first[0] as int;
  }

  Future<void> update(int id, String name) async {
    await db.execute(
      Sql.named('''
        UPDATE $schema.$table
        SET name=@name
        WHERE id=@id
        '''),
      parameters: {'id': id, 'name': name},
    );
  }

  Future<int> delete(int id) async {
    final result = await db.execute(
      Sql.named('DELETE FROM $schema.$table WHERE id=@id'),
      parameters: {'id': id},
    );

    return result.affectedRows;
  }
}
