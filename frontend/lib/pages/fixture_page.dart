import 'package:flutter/material.dart';
import 'package:lights_app/pages/mode_page.dart';
import 'package:lights_app/models/fixture_model.dart';
import 'package:lights_app/util/pop_ups.dart';
import 'package:lights_app/services/basic_api.dart';
import 'package:lights_app/services/fixtures_api.dart';

class FixturePage extends StatefulWidget {
  final int fixtureId;

  const FixturePage(this.fixtureId, {super.key});

  @override
  State<FixturePage> createState() => _FixturePageState();
}

class _FixturePageState extends State<FixturePage> {
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
          return Scaffold(body: const Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final fixtures = snapshot.data!.$1;
        final fixture = fixtures.firstWhere((f) => f.id == widget.fixtureId);
        final basicData = snapshot.data!.$2;

        return Scaffold(
          appBar: AppBar(title: Text(fixture.name)),

          body: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      margin: const EdgeInsets.all(16),

                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          final result = await PopUps.fixturePopup(
                            context: context,
                            basicData: basicData,
                            fixture: fixture,
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
                                fixture.name,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),

                              Text(basicData[1][fixture.manufacturerId]!),
                              Text(basicData[0][fixture.fixtureTypeId]!),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Text('${fixture.powerUsageWatt}W,'),
                                  const SizedBox(width: 12),

                                  Text(
                                    '${(fixture.powerUsageWatt / 230).toStringAsFixed(2)}A',
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(basicData[2][fixture.powerConnectorId]!),
                                  const SizedBox(width: 8),
                                  Text(
                                    fixture.hasPowerLink
                                        ? 'Has link'
                                        : 'No link',
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text("${fixture.modes.length} modes"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: fixture.modes.length,

                  itemBuilder: (context, index) {
                    final mode = fixture.modes[index];

                    return ListTile(
                      title: Text(mode.name),

                      subtitle: Text("${mode.channelCount} channels"),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ModePage(fixture.id, mode.id),
                          ),
                        );
                        setState(() {
                          _loadData();
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              bool? result = await PopUps.modePopup(
                context: context,
                fixtureId: fixture.id,
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
