import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:vault_shield_server/db.dart';
import 'package:vault_shield_server/service.dart';

void main(List<String> arguments) async {
  await myDB.open();
  const PORT = 8080;
  final service = Service();
  var server = await HttpServer.bind('localhost', PORT);
  shelf_io.serveRequests(server, service.handler);
  print(
    'Server running at http://${server.address.host}:$PORT',
  );
}
