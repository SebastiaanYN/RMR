# Web server framework for Dart
**RMR** allows you to easily create a scalable server backend for your web applications.

## Example
See `example/example.dart`
```dart
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
```

## Handlers and Middleware
**RMR** is a middleware based framework. This means requests can be handled in separate parts allowing you to group
common functionality together. When `rmr.next()` is called execution is passed on to the next handler. **RMR** also hides
a lot of the ugly code that comes with writing a server by providing some handy shortcuts. Such as listening for specific
request methods and paths, sending `html`, `css`, `js` and `json` data to the client and more.