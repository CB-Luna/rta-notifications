import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'rta/mailutils.dart' as api;
import 'dart:convert' as convert;

class Notifications {
  Notifications();

  Handler get router {
    final router = Router();

    router.post('/api', (Request req) async {
      dynamic result;
      String body = await req.readAsString();
      Map postData = convert.JsonDecoder().convert(body);
      print(postData);
      switch (postData["action"]) {
        case "rtaMail":
          result = await api.sendMail(postData);
          break;
        default:
          result = {
            'code': '9999',
            'msg': "Error",
            'result': 'Action not found'
          };
      }
      result = convert.json.encode(result);
      return Response.ok(result, headers: {
        'content-type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST',
      });
    });

    router.options('/api', (Request req) async {
      return Response.ok("", headers: {
        'Access-Control-Allow-Headers': 'content-type',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST',
      });
    });

    return router;
  }
}
