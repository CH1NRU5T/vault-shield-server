import 'package:mongo_dart/mongo_dart.dart';

import './db.dart';

DbCollection users = myDB.collection('users');
DbCollection passwordCollection = myDB.collection('passwords');
