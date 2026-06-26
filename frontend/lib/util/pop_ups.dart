import 'package:flutter/material.dart';
import 'package:lights_app/models/channel_model.dart';
import 'package:lights_app/models/fixture_model.dart';
import 'package:lights_app/models/mode_model.dart';
import 'package:lights_app/services/fixtures_api.dart';

class PopUps {
  static Future<bool?> fixturePopup({
    required BuildContext context,
    required List<Map<int, String>> basicData,
    Fixture? fixture,
  }) {
    final nameController = TextEditingController();
    nameController.text = fixture?.name ?? '';
    final wattController = TextEditingController();
    wattController.text = fixture?.powerUsageWatt.toString() ?? '';
    bool checkboxValue = fixture?.hasPowerLink ?? false;
    int? fixtureTypeDropdownValue = fixture?.fixtureTypeId;
    int? manufacturerDropdownValue = fixture?.manufacturerId;
    int? powerConnectorDropdownValue = fixture?.powerConnectorId;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create new'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                Row(
                  children: [
                    DropdownButton<int>(
                      hint: const Text('Manufacturer'),
                      value: manufacturerDropdownValue,
                      items: (basicData[1]).entries
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e.key,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => manufacturerDropdownValue = val),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<int>(
                      hint: const Text('Fixture Type'),
                      value: fixtureTypeDropdownValue,
                      items: (basicData[0]).entries
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e.key,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setDialogState(() => fixtureTypeDropdownValue = val),
                    ),
                  ],
                ),
                TextField(
                  controller: wattController,
                  decoration: const InputDecoration(
                    labelText: 'Power Usage (W)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    DropdownButton<int>(
                      hint: const Text('Power Connector'),
                      value: powerConnectorDropdownValue,
                      items: (basicData[2]).entries
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e.key,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setDialogState(
                        () => powerConnectorDropdownValue = val,
                      ),
                    ),
                    Checkbox(
                      value: checkboxValue,
                      onChanged: (val) =>
                          setDialogState(() => checkboxValue = val!),
                    ),
                    const Text('Has Power Link'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final powerUsage = int.tryParse(wattController.text);
                if (fixtureTypeDropdownValue != null &&
                    manufacturerDropdownValue != null &&
                    powerConnectorDropdownValue != null &&
                    nameController.text.isNotEmpty &&
                    powerUsage != null) {
                  fixture != null
                      ? await FixturesApi.updateFixture(
                          id: fixture.id,
                          fixtureTypeId: fixtureTypeDropdownValue!,
                          name: nameController.text,
                          manufacturerId: manufacturerDropdownValue!,
                          powerUsageWatt: powerUsage,
                          powerConnectorId: powerConnectorDropdownValue!,
                          hasPowerLink: checkboxValue,
                        )
                      : await FixturesApi.createFixture(
                          fixtureTypeId: fixtureTypeDropdownValue!,
                          name: nameController.text,
                          manufacturerId: manufacturerDropdownValue!,
                          powerUsageWatt: powerUsage,
                          powerConnectorId: powerConnectorDropdownValue!,
                          hasPowerLink: checkboxValue,
                        );
                }
                Navigator.pop(context, true);
              },
              child: Text(fixture != null ? 'Update' : 'Create'),
            ),
            if (fixture != null)
              TextButton(
                onPressed: () async {
                  await FixturesApi.deleteFixture(id: fixture.id);
                  Navigator.pop(context, false);
                },
                child: Text(
                  'Delete',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> modePopup({
    required BuildContext context,
    int? fixtureId,
    Mode? mode,
  }) {
    final nameController = TextEditingController();
    nameController.text = mode?.name ?? '';
    final channelCountController = TextEditingController();
    channelCountController.text = mode?.channelCount.toString() ?? '';

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create new'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: channelCountController,
              decoration: const InputDecoration(labelText: 'Channel Count'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final channelCount = int.tryParse(channelCountController.text);
              if (nameController.text.isNotEmpty && channelCount != null) {
                mode != null
                    ? await FixturesApi.updateMode(
                        id: mode.id,
                        name: nameController.text,
                        channelCount: channelCount,
                      )
                    : await FixturesApi.createMode(
                        fixtureId: fixtureId!,
                        name: nameController.text,
                        channelCount: channelCount,
                      );
              }
              Navigator.pop(context, true);
            },
            child: Text(mode != null ? 'Update' : 'Create'),
          ),
          if (mode != null)
            TextButton(
              onPressed: () async {
                await FixturesApi.deleteMode(id: mode.id);
                Navigator.pop(context, false);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  static Future<bool?> channelPopup({
    required BuildContext context,
    required List<Map<int, String>> basicData,
    int? modeId,
    Channel? channel,
  }) {
    final channelNumberController = TextEditingController();
    channelNumberController.text = channel?.channelNumber.toString() ?? '';
    int? channelContentDropdownValue = channel?.channelContentId;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create new'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: channelNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Channel Number',
                  ),
                ),
                DropdownButton<int>(
                  hint: const Text('Channel Content'),
                  value: channelContentDropdownValue,
                  items: (basicData[3]).entries
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                  onChanged: (val) =>
                      setDialogState(() => channelContentDropdownValue = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final channelNumber = int.tryParse(
                  channelNumberController.text,
                );
                if (channelContentDropdownValue != null &&
                    channelNumber != null) {
                  channel != null
                      ? await FixturesApi.updateChannel(
                          id: channel.id,
                          channelNumber: channelNumber,
                          channelContentId: channelContentDropdownValue!,
                        )
                      : await FixturesApi.createChannel(
                          modeId: modeId!,
                          channelNumber: channelNumber,
                          channelContentId: channelContentDropdownValue!,
                        );
                }
                Navigator.pop(context, true);
              },
              child: Text(channel != null ? 'Update' : 'Create'),
            ),
            if (channel != null)
              TextButton(
                onPressed: () async {
                  await FixturesApi.deleteChannel(id: channel.id);
                  Navigator.pop(context, false);
                },
                child: Text(
                  'Delete',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
