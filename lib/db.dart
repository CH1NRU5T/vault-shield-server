import 'package:mongo_dart/mongo_dart.dart';

Db? db;
Future<void> init() async {
  db = await Db.create(
      'mongodb+srv://chinrust:yAqzDpZCVwk7GUwi@cluster0.cvklnl1.mongodb.net');
}
// Db myDB =
//     await Db.create('mongodb+srv://chinrust:yAqzDpZCVwk7GUwi@cluster0.cvklnl1.mongodb.net');
