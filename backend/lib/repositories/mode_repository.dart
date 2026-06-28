import 'package:app_core/database/database.dart';
import 'package:postgres/postgres.dart';

class ModeRepository {
  final Database db;
  ModeRepository() : db = Database.instance;

  // mode
  Future<int> createMode(int fixtureId, String name, int channelCount) async {
    final result = await db.execute(
      Sql.named('''
        INSERT INTO fixture_library.mode (fixture_id, name, channel_count)
        VALUES (@fixtureId, @name, @channelCount)
        RETURNING id
      '''),
      parameters: {
        'fixtureId': fixtureId,
        'name': name,
        'channelCount': channelCount,
      },
    );
    return result.first[0] as int;
  }

  Future<void> updateMode(int id, String name, int channelCount) async {
    await db.execute(
      Sql.named('''
        UPDATE fixture_library.mode
        SET name = @name,
            channel_count = @channelCount
        WHERE id = @id
      '''),
      parameters: {'id': id, 'name': name, 'channelCount': channelCount},
    );
  }

  Future<void> deleteMode(int id) async {
    await db.execute(
      Sql.named('DELETE FROM fixture_library.mode WHERE id = @id'),
      parameters: {'id': id},
    );
  }
}
