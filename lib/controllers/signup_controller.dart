import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:vault_shield_server/collections.dart';
import 'package:vault_shield_server/custom_response.dart';
import 'package:vault_shield_server/models/user_model.dart';

Future<Response> signup(Request request) async {
  try {
    Map<String, dynamic> body = jsonDecode(await request.readAsString());
    if (body['email'] == null || body['email'] == '') {
      return badRequestJson({'error': 'Email is required'});
    }
    if (body['password'] == null || body['password'] == '') {
      return badRequestJson({'error': 'Password is required'});
    }
    if (body['name'] == null || body['name'] == '') {
      return badRequestJson({'error': 'Name is required'});
    }
    if (body['publicKey'] == null || body['publicKey'] == '') {
      return badRequestJson({'error': 'Some error occurred, please try again'});
    }
    User? user = await User.findOne(body['email']);
    if (user != null) {
      return badRequestJson({'error': 'User already exists'});
    }

    String hashedPassword =
        DBCrypt().hashpw(body['password'], DBCrypt().gensalt());
    user = User(
      email: body['email'],
      password: hashedPassword,
      name: body['name'],
      publicKey: body['publicKey'],
    );
    // save user to db
    WriteResult result = await users.insertOne(user.toMap());
    if (result.writeConcernError != null) {
      return internalServerErrorJson(
          {'error': 'Error saving user to DB: ${result.writeConcernError}'});
    }
    return okJson({
      'message': 'User created successfully',
      'token': JWT(
        {
          'email': user.email,
          'name': user.name,
          'id': user.id,
        },
      ).sign(SecretKey('secretKey')),
      ...user.toMap()..remove('password')
    });
  } catch (e) {
    return internalServerErrorJson({'error': e.toString()});
  }
}
