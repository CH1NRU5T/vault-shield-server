// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:vault_shield_server/collections.dart';

class Password {
  final ObjectId? id;
  final String password;
  final String username;
  final String website;
  final ObjectId userId;
  Password({
    this.id,
    required this.password,
    required this.username,
    required this.website,
    required this.userId,
  });

  Password copyWith({
    ObjectId? id,
    String? password,
    String? username,
    String? website,
    ObjectId? userId,
  }) {
    return Password(
      id: id ?? this.id,
      password: password ?? this.password,
      username: username ?? this.username,
      website: website ?? this.website,
      userId: userId ?? this.userId,
    );
  }

  static Future<List<Password>> getSavedPasswords(String userId) async {
    try {
      List<Map<String, dynamic>> savedPasswords = [];
      passwordCollection
          .find({'userId': ObjectId.parse(userId)}).listen((event) {
        savedPasswords.add(event);
      });
      return savedPasswords.map((e) => Password.fromMap(e)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'password': password,
      'username': username,
      'website': website,
    };
  }

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      userId: map['userId'] as ObjectId,
      password: map['password'] as String,
      username: map['username'] as String,
      website: map['website'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Password.fromJson(String source) =>
      Password.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SavedPassword(id: $id, password: $password, username: $username, website: $website)';
  }
}
