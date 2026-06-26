import 'package:lightsapp_backend/models/channel.dart';

class Mode {
  final int id;
  final String name;
  final int channelCount;
  final List<Channel> channels;

  Mode({
    required this.id,
    required this.name,
    required this.channelCount,
    required this.channels,
  });

  factory Mode.fromSql(
    Map<String, dynamic> map, {
    List<Channel>? channelList,
  }) {
    return Mode(
      id: map['id'],
      name: map['name'],
      channelCount: map['channel_count'],
      channels: channelList ?? List.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'channel_count': channelCount,
    'channels': channels.map((mode) => mode.toJson()).toList(),
  };
}
