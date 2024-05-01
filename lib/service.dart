import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vault_shield_server/controllers/login_controller.dart';
import 'package:vault_shield_server/controllers/passwords_controller.dart';
import 'package:vault_shield_server/controllers/save_password_controller.dart';
import 'package:vault_shield_server/controllers/signup_controller.dart';

class Service {
  Handler get handler {
    final router = Router();
    router.get('/', (Request request) {
      return Response.ok('Hello, World! ');
    });
    router.post('/login', login);
    router.post('/signup', signup);
    router.post('/save', savePassword);
    router.get('/passwords', passwords);
    return router;
  }
}
