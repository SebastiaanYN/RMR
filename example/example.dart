import 'dart:io';

import 'package:rmr/rmr.dart';

void main() async {
  Server server = Server();

  server.get(Path('/'), [
    (rmr) {
      print('Got a request on ${rmr.req.uri}');
      rmr.next();
    },
    (rmr) {
      rmr.html(HttpStatus.ok, '<h1>Hello from RMR</h1>');
    }
  ]);

  server.listen(InternetAddress.loopbackIPv4, 4040, (server) {
    print('Listening on ${server.address} port ${server.port}');
  });
}
