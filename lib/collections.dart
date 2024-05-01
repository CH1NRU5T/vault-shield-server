import 'package:mongo_dart/mongo_dart.dart';

import './db.dart';

DbCollection users = db!.collection('users');
DbCollection passwordCollection = db!.collection('passwords');
