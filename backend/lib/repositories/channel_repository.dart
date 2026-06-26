import 'package:lightsapp_backend/database/database.dart';
import 'package:lightsapp_backend/database/database_connection.dart';
import 'package:postgres/postgres.dart';

class ChannelRepository {
  final Database db;

  ChannelRepository({Database? db}) : db = db ?? DatabaseConnection();

  // channel
  Future<int> createChannel(
    int modeId,
    int channelNumber,
    int channelContentId,
  ) async {
    final result = await db.execute(
      Sql.named('''
        INSERT INTO fixture_library.channel (mode_id, channel_number, channel_content_id)
        VALUES (@modeId, @channelNumber, @channelContentId)
        RETURNING id
      '''),
      parameters: {
        'modeId': modeId,
        'channelNumber': channelNumber,
        'channelContentId': channelContentId,
      },
    );
    return result.first[0] as int;
  }

  Future<void> updateChannel(
    int id,
    int channelNumber,
    int channelContentId,
  ) async {
    await db.execute(
      Sql.named('''
        UPDATE fixture_library.channel
        SET channel_number = @channelNumber,
            channel_content_id = @channelContentId
        WHERE id = @id
      '''),
      parameters: {
        'id': id,
        'channelNumber': channelNumber,
        'channelContentId': channelContentId,
      },
    );
  }

  Future<void> deletechannel(int id) async {
    await db.execute(
      Sql.named('DELETE FROM fixture_library.channel WHERE id = @id'),
      parameters: {'id': id},
    );
  }
}
