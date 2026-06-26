import 'package:lights_app/models/channel_model.dart';

class Mode {
  int id;
  String name;
  int channelCount;
  List<Channel> channels;

  Mode({
    required this.id,
    required this.name,
    required this.channelCount,
    required this.channels,
  });

  factory Mode.fromMap(Map<String, dynamic> map) {
    return Mode(
      id: map['id'],
      name: map['name'],
      channelCount: map['channel_count'],
      channels: (map['channels'] as List)
          .map((channel) => Channel.fromMap(channel as Map<String, dynamic>))
          .toList(),
    );
  }

  void sortChannelsByNumber() {
    channels.sort((a, b) => a.channelNumber.compareTo(b.channelNumber));
  }
}
