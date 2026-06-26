// lib/main.dart

import 'package:flutter/material.dart';
import 'artnet_service.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DmxPage());
  }
}

class DmxPage extends StatefulWidget {
  const DmxPage({super.key});

  @override
  State<DmxPage> createState() => _DmxPageState();
}

class _DmxPageState extends State<DmxPage> {
  List<String> discoveredNodes = [];
  bool scanning = false;
  ArtNetService? artnet;

  final ipController = TextEditingController(text: '192.168.1.50');

  int ch1 = 0;
  int ch2 = 0;

  @override
  void initState() {
    super.initState();
    connectToNode(ipController.text);
  }

  Future<void> connectToNode(String ip) async {
    artnet?.dispose();

    artnet = ArtNetService(nodeIp: ip);
    await artnet!.init();

    setState(() {});
  }

  void send() {
    if (artnet == null) return;

    final universe = List<int>.filled(512, 0);

    universe[0] = ch1;
    universe[1] = ch2;

    artnet!.sendDmx(universe: 0, channels: universe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ipController.text)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: 'Art-Net Node IP',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                connectToNode(ipController.text.trim());
              },
              child: const Text('Connect'),
            ),

            const SizedBox(height: 24),

            Text('Channel 1: $ch1'),

            Slider(
              min: 0,
              max: 255,
              value: ch1.toDouble(),
              onChanged: (v) {
                setState(() => ch1 = v.toInt());
                send();
              },
            ),

            const SizedBox(height: 24),

            Text('Channel 2: $ch2'),

            Slider(
              min: 0,
              max: 255,
              value: ch2.toDouble(),
              onChanged: (v) {
                setState(() => ch2 = v.toInt());
                send();
              },
            ),
            const Divider(height: 48),

            const Text(
              'Art-Net Discovery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: scanning ? null : discoverNodes,
              child: Text(scanning ? 'Scanning...' : 'Discover Nodes'),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: discoveredNodes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.router),
                    title: Text(discoveredNodes[index]),
                  );
                },
              ),
            ),
            if (!scanning && discoveredNodes.isEmpty)
              const Text('No Art-Net nodes found'),
          ],
        ),
      ),
    );
  }

  Future<void> discoverNodes() async {
    setState(() {
      scanning = true;
      discoveredNodes.clear();
    });

    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    socket.broadcastEnabled = true;

    final pollPacket = <int>[
      // "Art-Net\0"
      0x41,
      0x72,
      0x74,
      0x2D,
      0x4E,
      0x65,
      0x74,
      0x00,

      // OpPoll = 0x2000 (little endian)
      0x00,
      0x20,

      // Protocol version 14
      0x00,
      0x0E,

      // TalkToMe
      0x00,

      // Priority
      0x00,
    ];

    socket.send(pollPacket, InternetAddress('255.255.255.255'), 6454);

    final found = <String>{};

    late StreamSubscription subscription;

    subscription = socket.listen((event) {
      if (event != RawSocketEvent.read) return;

      final datagram = socket.receive();
      if (datagram == null) return;

      final data = datagram.data;

      if (data.length < 10) return;

      final header = String.fromCharCodes(data.sublist(0, 8));

      if (header != 'Art-Net\u0000') return;

      final opcode = data[8] | (data[9] << 8);

      if (opcode != 0x2100) return; // ArtPollReply

      String shortName = '';

      if (data.length > 108) {
        final nameBytes = data.sublist(26, 44);

        shortName = String.fromCharCodes(
          nameBytes,
        ).replaceAll('\u0000', '').trim();
      }

      found.add('${datagram.address.address}  $shortName');

      setState(() {
        discoveredNodes = found.toList();
      });
    });

    await Future.delayed(const Duration(seconds: 2));

    await subscription.cancel();
    socket.close();

    setState(() {
      scanning = false;
    });
  }

  @override
  void dispose() {
    ipController.dispose();
    artnet?.dispose();
    super.dispose();
  }
}
