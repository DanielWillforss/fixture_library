// lib/artnet_service.dart

import 'dart:io';
import 'dart:typed_data';

class ArtNetService {
  final String nodeIp;
  final int port;

  RawDatagramSocket? _socket;

  ArtNetService({required this.nodeIp, this.port = 6454});

  Future<void> init() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  }

  void sendDmx({required int universe, required List<int> channels}) {
    final packet = _buildArtDmxPacket(universe: universe, dmxData: channels);

    _socket?.send(packet, InternetAddress(nodeIp), port);
  }

  Uint8List _buildArtDmxPacket({
    required int universe,
    required List<int> dmxData,
  }) {
    final data = Uint8List(18 + dmxData.length);

    final header = [0x41, 0x72, 0x74, 0x2D, 0x4E, 0x65, 0x74, 0x00];

    data.setRange(0, 8, header);

    data[8] = 0x00;
    data[9] = 0x50;

    data[10] = 0x00;
    data[11] = 0x0E;

    data[12] = 0x00;

    data[13] = 0x00;

    data[14] = universe & 0xFF;
    data[15] = (universe >> 8) & 0xFF;

    data[16] = (dmxData.length >> 8) & 0xFF;
    data[17] = dmxData.length & 0xFF;

    data.setRange(18, 18 + dmxData.length, dmxData);

    return data;
  }

  void dispose() {
    _socket?.close();
  }
}
