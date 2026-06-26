// import 'package:lightsapp_backend/repositories/basic/repository_implementations.dart';
// import 'package:lightsapp_backend/repositories/mode_repository.dart';
// import 'package:lightsapp_backend/repositories/fixture_repository.dart';
// import 'package:postgres/postgres.dart';
// import 'package:test/test.dart';

// import '../test_util.dart';

// void main() {
//   final db = TestDatabaseConnection();
//   final repo = ModeRepository(db: db);

//   setUp(() => db.setUp());
//   tearDown(() => db.tearDown());

//   Future<int> createFixture() async {
//     final fixtureType = await FixtureTypeRepository(
//       db: db,
//     ).create('Moving Head');

//     final manufacturer = await ManufacturerRepository(db: db).create('Martin');

//     final connector = await PowerConnectorRepository(db: db).create('PowerCon');

//     return FixtureRepository(db: db).create(
//       fixtureTypeId: fixtureType,
//       name: 'MAC Aura',
//       manufacturerId: manufacturer,
//       powerUsageWatt: 100,
//       powerConnectorId: connector,
//       powerLink: true,
//     );
//   }

//   test('createMode inserts row', () async {
//     final fixtureId = await createFixture();

//     final id = await repo.createMode(fixtureId, 'Standard', 16);

//     expect(id, greaterThan(0));
//   });

//   test('updateMode updates row', () async {
//     final fixtureId = await createFixture();

//     final id = await repo.createMode(fixtureId, 'Standard', 16);

//     await repo.updateMode(id, 'Extended', 24);

//     final result = await db.execute(
//       Sql.named('SELECT * FROM fixture_library.mode WHERE id=@id'),
//       parameters: {'id': id},
//     );

//     final row = result.single.toColumnMap();

//     expect(row['name'], 'Extended');
//     expect(row['channel_count'], 24);
//   });

//   test('deleteMode removes row', () async {
//     final fixtureId = await createFixture();

//     final id = await repo.createMode(fixtureId, 'Standard', 16);

//     await repo.deleteMode(id);

//     final result = await db.execute(
//       Sql.named('SELECT * FROM fixture_library.mode WHERE id=@id'),
//       parameters: {'id': id},
//     );

//     expect(result, isEmpty);
//   });
// }
