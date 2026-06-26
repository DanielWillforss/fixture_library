import 'package:flutter/material.dart';
import 'package:lights_app/models/fixture_model.dart';
import 'package:lights_app/pages/base_info_page.dart';
import 'package:lights_app/pages/fixture_page.dart';
import 'package:lights_app/util/pop_ups.dart';
import 'package:lights_app/services/basic_api.dart';
import 'package:lights_app/services/fixtures_api.dart';

class FixturesPage extends StatefulWidget {
  const FixturesPage({super.key});

  @override
  State<FixturesPage> createState() => _FixturesPageState();
}

class _FixturesPageState extends State<FixturesPage> {
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
        final basicData = snapshot.data!.$2;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Fixtures"),

            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BaseInfoPage()),
                  );
                },
              ),
            ],
          ),

          body: ListView.builder(
            itemCount: fixtures.length,

            itemBuilder: (context, index) {
              final fixture = fixtures[index];

              return ListTile(
                
                title: Text(fixture.name),

                subtitle: Text(basicData[1][fixture.manufacturerId]!),

                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FixturePage(fixture.id)),
                  );
                  setState(() {
                    _loadData();
                  });
                },
              );
            },
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              bool? result = await PopUps.fixturePopup(
                context: context,
                basicData: basicData,
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
