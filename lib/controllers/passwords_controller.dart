import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:vault_shield_server/collections.dart';
import 'package:vault_shield_server/custom_response.dart';
import 'package:vault_shield_server/models/saved_password.dart';

Future<Response> passwords(Request request) async {
  Map<String, String> headers = request.headers;
  try {
    if (headers['Authorization'] == null || headers['Authorization'] == '') {
      return badRequestJson({'error': 'Not Authorized'});
    }
    final token = headers['Authorization']!.split(' ')[1];
    JWT jwt = JWT.verify(token, SecretKey('secretKey'));
    if (jwt.payload['id'] == null || jwt.payload['id'] == '') {
      return badRequestJson({'error': 'Not Authorized'});
    }
    final res = passwordCollection.find({
      'userId': ObjectId.parse(jwt.payload['id']),
    });
    List<Password> passwords = [];
    await for (var obj in res) {
      passwords.add(Password.fromMap(obj));
    }
    return okJson({
      'passwords': passwords.map((e) => e.toMap()).toList(),
      'message': 'Success'
    });
  } catch (e) {
    return internalServerErrorJson({'error': e.toString()});
  }
}
