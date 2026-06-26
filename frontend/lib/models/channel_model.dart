class Channel {
  int id;
  int channelNumber;
  int channelContentId;

  Channel({
    required this.id,
    required this.channelNumber,
    required this.channelContentId,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      channelNumber: map['channel_number'],
      channelContentId: map['channel_content_id'],
    );
  }
}
