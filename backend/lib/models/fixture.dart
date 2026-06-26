import 'package:lightsapp_backend/models/mode.dart';

class Fixture {
  final int id;
  final int fixtureTypeId;
  final String name;
  final int manufacturerId;
  final int powerUsageWatt;
  final int powerConnectorId;
  final bool hasPowerLink;
  final List<Mode> modes;

  Fixture({
    required this.id,
    required this.fixtureTypeId,
    required this.name,
    required this.manufacturerId,
    required this.powerUsageWatt,
    required this.powerConnectorId,
    required this.hasPowerLink,
    required this.modes,
  });

  factory Fixture.fromSql(
    Map<String, dynamic> map, {
    List<Mode>? modeList,
  }) {
    return Fixture(
      id: map['id'],
      fixtureTypeId: map['fixture_type_id'],
      name: map['name'],
      manufacturerId: map['manufacturer_id'],
      powerUsageWatt: map['power_usage_watt'],
      powerConnectorId: map['power_connector_id'],
      hasPowerLink: map['has_power_link'],
      modes: modeList ?? List.empty(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fixture_type_id': fixtureTypeId,
    'name': name,
    'manufacturer_id': manufacturerId,
    'power_usage_watt': powerUsageWatt,
    'power_connector_id': powerConnectorId,
    'has_power_link': hasPowerLink,
    'modes': modes.map((mode) => mode.toJson()).toList(),
  };
}
