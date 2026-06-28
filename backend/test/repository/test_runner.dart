// import 'package:lightsapp_backend/database/database.dart';
// import 'package:lightsapp_backend/repositories/basic/basic_base_repository.dart';
// import 'package:lightsapp_backend/repositories/basic/repository_implementations.dart';
// import 'package:test/test.dart';
// import '../test_util.dart';

// setUp(() async {
//   Database.init(Endpoint(
//     host: 'localhost',
//     port: 5432,
//     database: 'test_db',
//     username: 'admin',
//     password: 'admin',
//   ), testMode: true);
//   await Database.instance.begin();
// });

// tearDown(() async {
//   await Database.instance.rollback();
// });






// void main() {
//   final db = TestDatabaseConnection.instance;

//   setUp(() => db.setUp());
//   tearDown(() => db.tearDown());

//   void runCrudTests(
//     String description,
//     BasicBaseRepository Function({Database? db}) factory,
//   ) {
//     group(description, () {
//       test('create inserts row', () async {
//         final repo = factory(db: db);
//         final id = await repo.create('Test');
//         expect(id, greaterThan(0));
//         final rows = await repo.getAll();
//         expect(rows.length, 1);
//         expect(rows.first['name'], 'Test');
//       });

//       test('getAll returns rows ordered by id', () async {
//         final repo = factory(db: db);
//         await repo.create('One');
//         await repo.create('Two');
//         final rows = await repo.getAll();
//         expect(rows.length, 2);
//         expect(rows[0]['name'], 'One');
//         expect(rows[1]['name'], 'Two');
//       });

//       test('update changes name', () async {
//         final repo = factory(db: db);
//         final id = await repo.create('Old');
//         await repo.update(id, 'New');
//         final rows = await repo.getAll();
//         expect(rows.single['name'], 'New');
//       });

//       test('delete removes row', () async {
//         final repo = factory(db: db);
//         final id = await repo.create('Delete Me');
//         final affected = await repo.delete(id);
//         expect(affected, 1);
//         final rows = await repo.getAll();
//         expect(rows, isEmpty);
//       });

//       test('delete nonexistent row returns 0', () async {
//         final repo = factory(db: db);
//         final affected = await repo.delete(999999);
//         expect(affected, 0);
//       });
//     });
//   }

//   runCrudTests(
//     'FixtureTypeRepository',
//     ({Database? db}) => FixtureTypeRepository(db: db),
//   );
//   runCrudTests(
//     'ManufacturerRepository',
//     ({Database? db}) => ManufacturerRepository(db: db),
//   );
//   runCrudTests(
//     'PowerConnectorRepository',
//     ({Database? db}) => PowerConnectorRepository(db: db),
//   );
//   // runCrudTests(
//   // 'ChannelTypeRepository',
//   // ({Database? db}) => ChannelTypeRepository(db: db),
//   // );
// }
