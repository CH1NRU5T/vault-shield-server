import 'dart:convert';
import 'dart:isolate';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:shelf/shelf.dart';
import 'package:vault_shield_server/custom_response.dart';
import 'package:vault_shield_server/models/user_model.dart';

Future<Response> login(Request request) async {
  print('/login ${Isolate.current.hashCode}');
  Map<String, dynamic> body = jsonDecode(await request.readAsString());
  try {
    if (body['email'] == null || body['email'] == '') {
      return badRequestJson({'error': 'Email is required'});
    }
    if (body['password'] == null || body['password'] == '') {
      return badRequestJson({'error': 'Password is required'});
    }
    User? user = await User.findOne(body['email']);
    if (user == null) {
      return badRequestJson({'error': 'User does not exist'});
    }
    if (!DBCrypt().checkpw(body['password'], user.password)) {
      return badRequestJson({'error': 'Invalid password'});
    }
    return okJson(
      {
        'message': 'Login successful',
        'token': JWT(
          {
            'email': user.email,
            'name': user.name,
            'id': user.id,
          },
        ).sign(SecretKey('secretKey')),
        ...user.toMap()..remove('password')
      },
    );
  } catch (e) {
    return internalServerErrorJson({'error': e.toString()});
  }
}
