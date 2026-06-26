import 'package:flutter/material.dart';
import 'package:lights_app/services/basic_api.dart';

class BaseInfoPage extends StatefulWidget {
  const BaseInfoPage({super.key});

  @override
  State<BaseInfoPage> createState() => _BaseInfoPageState();
}

class _BaseInfoPageState extends State<BaseInfoPage> {
  late Future<List<Map<int, String>>> _infoFuture;

  @override
  void initState() {
    super.initState();
    _loadBasics();
  }

  void _loadBasics() {
    _infoFuture = BasicApi.getAllBasic();
  }

  int page = 0;

  final tabs = [
    "Fixture Types",
    "Manufacturers",
    "Power Connectors",
    "Channel Contents",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tabs[page])),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final TextEditingController controller = TextEditingController();
          final String? name = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Create new'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Enter name'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, controller.text),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          );
          if (name != null && name.isNotEmpty) {
            await BasicApi.createBasic(name, page);
            setState(() {
              _loadBasics();
            });
          }
        },
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder(
        future: _infoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final basicInfo = snapshot.data!;
          if (basicInfo.isEmpty) {
            return const Center(child: Text('No info returned'));
          }

          List<List<int>> keys = basicInfo
              .map((map) => map.keys.toList())
              .toList();

          return ListView.builder(
            itemCount: basicInfo[page].length,
            itemBuilder: (context, index) {
              final int id = keys[page][index];
              final String entry = basicInfo[page][id]!;
              return ListTile(
                title: Text(entry),
                onTap: () async {
                  final TextEditingController controller =
                      TextEditingController(text: entry);
                  final result = await showDialog<(String, bool)>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Edit entry'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter name',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, ('', true)),
                          child: const Text('Delete'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, (controller.text, false)),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  );

                  if (result != null) {
                    if (result.$2) {
                      try {
                        await BasicApi.deleteBasic(id, page);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not delete')),
                        );
                      }
                    } else {
                      await BasicApi.updateBasic(id, result.$1, page);
                    }
                    setState(() {
                      _loadBasics();
                    });
                  }
                },
              );
            },
          );
        },
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: page,

        onDestinationSelected: (i) {
          setState(() {
            page = i;
          });
        },

        destinations: const [
          NavigationDestination(icon: Icon(Icons.speaker), label: "Type"),

          NavigationDestination(icon: Icon(Icons.business), label: "Manu."),

          NavigationDestination(icon: Icon(Icons.cable), label: "Connector"),

          NavigationDestination(icon: Icon(Icons.color_lens), label: "Content"),
        ],
      ),
    );
  }
}
