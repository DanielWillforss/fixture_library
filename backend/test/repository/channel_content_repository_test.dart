// import 'package:lightsapp_backend/repositories/basic/repository_implementations.dart';
// import 'package:test/test.dart';

// import '../test_util.dart';

// void main() {
//   final db = TestDatabaseConnection();
//   final repo = ChannelContentRepository(db: db);
  
//   setUp(() => db.setUp());
//   tearDown(() => db.tearDown());

//   test('createContent inserts row', () async {
    
//     final id = await repo.createContent('Red');

//     expect(id, greaterThan(0));

//     final rows = await repo.getAll();

//     expect(rows.single['name'], 'Red');
//     expect(rows.single['type_id'], typeId);
//   });

//   test('updateContent updates values', () async {
//     final typeA = await typeRepo.create('Color');
//     final typeB = await typeRepo.create('Beam');

//     final id = await repo.createContent(typeA, 'Red');

//     await repo.updateContent(id, typeB, 'Focus');

//     final rows = await repo.getAll();

//     expect(rows.single['name'], 'Focus');
//     expect(rows.single['type_id'], typeB);
//   });

//   test('delete removes content', () async {
//     final typeId = await typeRepo.create('Color');

//     final id = await repo.createContent(typeId, 'Red');

//     final affected = await repo.delete(id);

//     expect(affected, 1);
//     expect(await repo.getAll(), isEmpty);
//   });
// }
