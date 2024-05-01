import 'dart:convert';

import 'package:shelf/shelf.dart';

Response okJson(Map<String, dynamic> map) => Response.ok(
      jsonEncode(map),
      headers: {
        'Content-Type': 'application/json',
      },
    );
Response internalServerErrorJson(Map<String, dynamic> map) =>
    Response.internalServerError(
      body: jsonEncode(map),
      headers: {
        'Content-Type': 'application/json',
      },
    );
Response notFoundJson(Map<String, dynamic> map) => Response.notFound(
      jsonEncode(map),
      headers: {
        'Content-Type': 'application/json',
      },
    );
Response forbiddenJson(Map<String, dynamic> map) => Response.forbidden(
      jsonEncode(map),
      headers: {
        'Content-Type': 'application/json',
      },
    );
Response badRequestJson(Map<String, dynamic> map) => Response.badRequest(
      body: jsonEncode(map),
      headers: {
        'Content-Type': 'application/json',
      },
    );
Response unauthorizedJson(Map<String, dynamic> map) => Response.unauthorized(
      jsonEncode(map),
      headers: {
        'Content-Type': 'application/json',
      },
    );
