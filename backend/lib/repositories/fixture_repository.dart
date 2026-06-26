// lib/repositories/fixture_repository.dart

import 'package:lightsapp_backend/database/database.dart';
import 'package:lightsapp_backend/database/database_connection.dart';
import 'package:lightsapp_backend/models/fixture.dart';
import 'package:lightsapp_backend/models/mode.dart';
import 'package:lightsapp_backend/models/channel.dart';
import 'package:postgres/postgres.dart';

class FixtureRepository {
  final Database db;
  FixtureRepository({Database? db}) : db = db ?? DatabaseConnection();

  // Gets all fixtures, with well compiled list of modes and channels
  Future<List<Fixture>> getAllFixtures() async {
    final modeChannels = await db.execute(
      Sql.named('SELECT * FROM fixture_library.channel ORDER BY id'),
    );
    Map<int, List<Channel>> channelMap = {};

    for (var row in modeChannels) {
      Map<String, dynamic> map = row.toColumnMap();
      channelMap
          .putIfAbsent(map['mode_id'], () => [])
          .add(Channel.fromSql(map));
    }

    final modes = await db.execute(
      Sql.named('SELECT * FROM fixture_library.mode ORDER BY id'),
    );

    Map<int, List<Mode>> modeMap = {};

    for (var row in modes) {
      Map<String, dynamic> map = row.toColumnMap();
      modeMap
          .putIfAbsent(map['fixture_id'], () => [])
          .add(Mode.fromSql(map, channelList: channelMap[map['id']]));
    }

    final fixtures = await db.execute(
      Sql.named('SELECT * FROM fixture_library.fixture ORDER BY id'),
    );

    return fixtures.map((row) {
      Map<String, dynamic> map = row.toColumnMap();
      return Fixture.fromSql(map, modeList: modeMap[map['id']]);
    }).toList();
  }

  // Create a new fixture
  Future<int> create({
    required int fixtureTypeId,
    required String name,
    required int manufacturerId,
    required int powerUsageWatt,
    required int powerConnectorId,
    required bool hasPowerLink,
  }) async {
    final result = await db.execute(
      '''
      INSERT INTO fixture_library.fixture(
        fixture_type_id,
        name,
        manufacturer_id,
        power_usage_watt,
        power_connector_id,
        has_power_link
      )
      VALUES(
        \$1,\$2,\$3,\$4,\$5,\$6
      )
      RETURNING id
      ''',
      parameters: [
        fixtureTypeId,
        name,
        manufacturerId,
        powerUsageWatt,
        powerConnectorId,
        hasPowerLink,
      ],
    );

    return result.first[0] as int;
  }

  Future<void> update({
    required int id,
    required int fixtureTypeId,
    required String name,
    required int manufacturerId,
    required int powerUsageWatt,
    required int powerConnectorId,
    required bool hasPowerLink,
  }) async {
    await db.execute(
      '''
      UPDATE fixture_library.fixture
      SET
        fixture_type_id=\$1,
        name=\$2,
        manufacturer_id=\$3,
        power_usage_watt=\$4,
        power_connector_id=\$5,
        has_power_link=\$6
      WHERE id=\$7
      ''',
      parameters: [
        fixtureTypeId,
        name,
        manufacturerId,
        powerUsageWatt,
        powerConnectorId,
        hasPowerLink,
        id,
      ],
    );
  }

  Future<int> delete(int id) async {
    final result = await db.execute(
      Sql.named('DELETE FROM fixture_library.fixture WHERE id=@id'),
      parameters: {'id': id},
    );

    return result.affectedRows;
  }
}
