import 'package:lights_app/models/mode_model.dart';

class Fixture {
  int id;
  int fixtureTypeId;
  String name;
  int manufacturerId;
  int powerUsageWatt;
  int powerConnectorId;
  bool hasPowerLink;
  List<Mode> modes;

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

  factory Fixture.fromMap(Map<String, dynamic> map) {
    return Fixture(
      id: map['id'],
      fixtureTypeId: map['fixture_type_id'],
      name: map['name'],
      manufacturerId: map['manufacturer_id'],
      powerUsageWatt: map['power_usage_watt'],
      powerConnectorId: map['power_connector_id'],
      hasPowerLink: map['has_power_link'],
      modes: (map['modes'] as List)
          .map((mode) => Mode.fromMap(mode as Map<String, dynamic>))
          .toList(),
    );
  }
}
