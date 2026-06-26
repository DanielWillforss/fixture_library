import 'package:flutter/material.dart';
import 'package:lights_app/models/fixture_model.dart';
import 'package:lights_app/util/pop_ups.dart';
import 'package:lights_app/services/basic_api.dart';
import 'package:lights_app/services/fixtures_api.dart';

class ModePage extends StatefulWidget {
  final int fixtureId;
  final int modeId;

  const ModePage(this.fixtureId, this.modeId, {super.key});

  @override
  State<ModePage> createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  late Future<(List<Fixture>, List<Map<int, String>>)> _dataFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _dataFuture =
        Future.wait([
          FixturesApi.getAllFixtures(),
          BasicApi.getAllBasic(),
        ]).then(
          (results) => (
            results[0] as List<Fixture>,
            results[1] as List<Map<int, String>>,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final fixtures = snapshot.data!.$1;
        final fixture = fixtures.firstWhere((f) => f.id == widget.fixtureId);
        final mode = fixture.modes.firstWhere((m) => m.id == widget.modeId);
        mode.sortChannelsByNumber();
        final basicData = snapshot.data!.$2;

        return Scaffold(
          appBar: AppBar(title: Text(mode.name)),

          body: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),

                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final result = await PopUps.modePopup(
                      context: context,
                      mode: mode,
                    );

                    if (result == true) {
                      setState(() {
                        _loadData();
                      });
                    } else if (result == false) {
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          mode.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),

                        Text("${mode.channelCount} channels"),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: mode.channels.length,

                  itemBuilder: (context, index) {
                    final channel = mode.channels[index];

                    return ListTile(
                      title: Text(
                        '${channel.channelNumber}: ${basicData[3][channel.channelContentId]!}',
                      ),
                      onTap: () async {
                        bool? result = await PopUps.channelPopup(
                          context: context,
                          basicData: basicData,
                          channel: channel,
                        );

                        if (result != null) {
                          setState(() {
                            _loadData();
                          });
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              bool? result = await PopUps.channelPopup(
                context: context,
                basicData: basicData,
                modeId: mode.id,
              );

              if (result == true) {
                setState(() {
                  _loadData();
                });
              }
            },

            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
