import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:vault_shield_server/collections.dart';

class User {
  final ObjectId? id;
  final String? name;
  final String password;
  final String email;
  final String? publicKey;
  final String? privateKey;
  User({
    this.name,
    required this.password,
    required this.email,
    this.id,
    this.publicKey,
    this.privateKey,
  });

  User copyWith({
    ObjectId? id,
    String? name,
    String? password,
    String? email,
    String? publicKey,
  }) {
    return User(
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      id: id ?? this.id,
      publicKey: publicKey ?? this.publicKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'password': password,
      'email': email,
    };
  }

  Future<User?> getOne(String id) async {
    try {
      Map<String, dynamic>? user =
          await users.findOne({'_id': ObjectId.parse(id)});
      if (user == null) {
        return null;
      }
      return User.fromMap(user);
    } catch (e) {
      throw Exception(e);
    }
  }

  factory User.fromMap(Map<String, dynamic> map) {
    try {
      return User(
        name: map['name'] != null ? map['name'] as String : null,
        password: map['password'] as String,
        email: map['email'] as String,
        id: map['_id'] != null ? map['_id'] as ObjectId : null,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(name: $name, password: $password, email: $email)';

  static Future<User?> findOne(String email) async {
    Map<String, dynamic>? user = await users.findOne({'email': email});
    if (user == null) {
      return null;
    }
    return User.fromMap(user);
  }
}
