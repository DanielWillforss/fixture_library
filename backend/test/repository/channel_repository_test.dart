// import 'package:lightsapp_backend/repositories/basic/repository_implementations.dart';
// import 'package:lightsapp_backend/repositories/mode_repository.dart';
// import 'package:lightsapp_backend/repositories/fixture_repository.dart';
// import 'package:lightsapp_backend/repositories/channel_repository.dart';
// import 'package:postgres/postgres.dart';
// import 'package:test/test.dart';

// import '../test_util.dart';

// void main() {
//   final db = TestDatabaseConnection.instance;
//   final repo = ChannelRepository(db: db);

//   setUp(() => db.setUp());
//   tearDown(() => db.tearDown());

//   Future<(int, int)> createDependencies() async {
//     final typeId = await ChannelTypeRepository(db: db).create('Intensity');

//     final contentId = await ChannelContentRepository(
//       db: db,
//     ).createContent(typeId, 'Dimmer');

//     final fixtureType = await FixtureTypeRepository(
//       db: db,
//     ).create('Moving Head');

//     final manufacturer = await ManufacturerRepository(db: db).create('Martin');

//     final connector = await PowerConnectorRepository(db: db).create('PowerCon');

//     final fixtureId = await FixtureRepository(db: db).create(
//       fixtureTypeId: fixtureType,
//       name: 'MAC Aura',
//       manufacturerId: manufacturer,
//       powerUsageWatt: 100,
//       powerConnectorId: connector,
//       powerLink: true,
//     );

//     final modeId = await ModeRepository(
//       db: db,
//     ).createMode(fixtureId, 'Standard', 16);

//     return (modeId, contentId);
//   }

//   test('createchannel inserts row', () async {
//     final deps = await createDependencies();

//     final id = await repo.createChannel(deps.$1, 1, deps.$2);

//     expect(id, greaterThan(0));
//   });

//   test('updatechannel updates row', () async {
//     final deps = await createDependencies();

//     final id = await repo.createChannel(deps.$1, 1, deps.$2);

//     await repo.updateChannel(id, 5, deps.$2);

//     final result = await db.execute(
//       Sql.named('SELECT * FROM fixture_library.mode_channel WHERE id=@id'),
//       parameters: {'id': id},
//     );

//     final row = result.single.toColumnMap();

//     expect(row['channel_number'], 5);
//   });

//   test('deletechannel removes row', () async {
//     final deps = await createDependencies();

//     final id = await repo.createChannel(deps.$1, 1, deps.$2);

//     await repo.deletechannel(id);

//     final result = await db.execute(
//       Sql.named('SELECT * FROM fixture_library.channel WHERE id=@id'),
//       parameters: {'id': id},
//     );

//     expect(result, isEmpty);
//   });
// }
