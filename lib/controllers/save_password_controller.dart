import 'dart:convert';

import 'package:crypton/crypton.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as jwt;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:vault_shield_server/collections.dart';
import 'package:vault_shield_server/custom_response.dart';
import 'package:vault_shield_server/models/saved_password.dart';

Future<Response> savePassword(Request request) async {
  Map<String, dynamic> body = jsonDecode(await request.readAsString());
  if (body['password'] == null || body['password'] == '') {
    return badRequestJson({'error': 'Password is required'});
  }
  if (body['username'] == null || body['username'] == '') {
    return badRequestJson({'error': 'Username is required'});
  }
  if (body['website'] == null || body['website'] == '') {
    return badRequestJson({'error': 'Website is required'});
  }
  String? token = request.headers['Authorization'];
  if (token == null) {
    return unauthorizedJson({'error': 'Unauthorized, token is required'});
  }
  token = token.split(' ').last;
  // decode token
  jwt.JWT? jwtToken = jwt.JWT.tryDecode(token);
  if (jwtToken == null) {
    return unauthorizedJson({'error': 'Unauthorized, invalid token'});
  }
  String userId = jwtToken.payload['id'];
  // save password
  Password savedPassword = Password(
    userId: ObjectId.parse(userId),
    password: body['password'],
    username: body['username'],
    website: body['website'],
  );
  await passwordCollection.insert(savedPassword.toMap());

  RSAKeypair kp = RSAKeypair.fromRandom();
  final hehe = RSAKeypair(kp.privateKey);
  final a = RSAPrivateKey.fromPEM(hehe.privateKey.toPEM());
  return okJson({
    'message': 'Password saved successfully',
    'pem': kp.publicKey.toString(),
    'fpem': a.publicKey.toString()
  });
}
