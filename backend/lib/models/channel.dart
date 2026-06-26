class Channel {
  final int id;
  final int channelNumber;
  final int channelContentId;

  Channel({
    required this.id,
    required this.channelNumber,
    required this.channelContentId,
  });

  factory Channel.fromSql(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      channelNumber: map['channel_number'],
      channelContentId: map['channel_content_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'channel_number': channelNumber,
    'channel_content_id': channelContentId,
  };
}
