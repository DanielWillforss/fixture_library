// import 'package:lightsapp_backend/repositories/basic/repository_implementations.dart';
// import 'package:lightsapp_backend/repositories/fixture_repository.dart';
// import 'package:postgres/postgres.dart';
// import 'package:test/test.dart';

// import '../test_util.dart';

// void main() {
//   final db = TestDatabaseConnection.instance;

//   final fixtureRepo = FixtureRepository(db: db);
//   final fixtureTypeRepo = FixtureTypeRepository(db: db);
//   final manufacturerRepo = ManufacturerRepository(db: db);
//   final connectorRepo = PowerConnectorRepository(db: db);

//   setUp(() => db.setUp());
//   tearDown(() => db.tearDown());

//   Future<(int, int, int)> createDependencies() async {
//     final fixtureType = await fixtureTypeRepo.create('Moving Head');
//     final manufacturer = await manufacturerRepo.create('Martin');
//     final connector = await connectorRepo.create('PowerCon');

//     return (fixtureType, manufacturer, connector);
//   }

//   test('create fixture', () async {
//     final deps = await createDependencies();

//     final id = await fixtureRepo.create(
//       fixtureTypeId: deps.$1,
//       name: 'MAC Aura',
//       manufacturerId: deps.$2,
//       powerUsageWatt: 300,
//       powerConnectorId: deps.$3,
//       powerLink: true,
//     );

//     expect(id, greaterThan(0));
//   });

//   test('update fixture', () async {
//     final deps = await createDependencies();

//     final id = await fixtureRepo.create(
//       fixtureTypeId: deps.$1,
//       name: 'Old Name',
//       manufacturerId: deps.$2,
//       powerUsageWatt: 300,
//       powerConnectorId: deps.$3,
//       powerLink: true,
//     );

//     await fixtureRepo.update(
//       id: id,
//       fixtureTypeId: deps.$1,
//       name: 'New Name',
//       manufacturerId: deps.$2,
//       powerUsageWatt: 500,
//       powerConnectorId: deps.$3,
//       powerLink: false,
//     );

//     final result = await db.execute(
//       Sql.named('SELECT * FROM fixture_library.fixture WHERE id=@id'),
//       parameters: {'id': id},
//     );

//     final row = result.single.toColumnMap();

//     expect(row['name'], 'New Name');
//     expect(row['power_usage_watt'], 500);
//     expect(row['power_link'], false);
//     expect(row['notes'], 'Updated');
//   });

//   test('delete fixture', () async {
//     final deps = await createDependencies();

//     final id = await fixtureRepo.create(
//       fixtureTypeId: deps.$1,
//       name: 'Delete Me',
//       manufacturerId: deps.$2,
//       powerUsageWatt: 100,
//       powerConnectorId: deps.$3,
//       powerLink: true,
//     );

//     final affected = await fixtureRepo.delete(id);

//     expect(affected, 1);
//   });
// }
