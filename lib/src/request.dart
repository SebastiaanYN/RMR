import 'dart:async';
import 'dart:convert';
import 'dart:io';

import './path.dart';
import '../rmr.dart';

/// A general object that holds data from a request.
class RMR {
  /// The original [HttpRequest]
  HttpRequest req;

  /// The [HttpResponse] to send data back to the client.
  HttpResponse res;

  /// The [Path] instance of this route.
  Path path;

  /// A list of all [RequestHandler] objects for this route.
  List<RequestHandler> handlers;

  int _index = 0;

  /// Creates a new [RMR] with the data provided.
  ///
  /// This shouldn't serve much of a practical use outside of this package itself.
  RMR(this.req, this.res, this.path, this.handlers);

  /// Passes execution on to the next [RequestHandler] if there is one present.
  void next() {
    if (_index < handlers.length) {
      try {
        handlers[_index++](this);
      } catch (e) {
        print(e);
        res
          ..statusCode = HttpStatus.internalServerError
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({'error': 'An unknown error occured'}))
          ..close();
      }
    }
  }

  /// The body of the [HttpRequest], if present.
  Future<String> get body async => await req.transform(utf8.decoder).join();

  /// The matches of the [Path].
  ///
  /// This is only applicable if the [Path] is a [RegExp].
  Match get matches => path.getMatches(req.requestedUri.path);

  /// Return HTML back to the client.
  void html(int status, Object html) {
    res
      ..statusCode = status
      ..headers.contentType = ContentType.html
      ..write(html)
      ..close();
  }

  /// Return CSS back to the client.
  void css(int status, Object css) {
    res
      ..statusCode = status
      ..headers.contentType = ContentType('text', 'css', charset: 'utf-8')
      ..write(css)
      ..close();
  }

  /// Return JavaScript back to the client.
  void js(int status, Object js) {
    res
      ..statusCode = status
      ..headers.contentType =
          ContentType('application', 'javascript', charset: 'utf-8')
      ..write(js)
      ..close();
  }

  /// Return JSON back to the client.
  void json(int status, Object json) {
    res
      ..statusCode = status
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(json))
      ..close();
  }

  /// Redirect the request to a different url.
  void redirect(String url) {
    res
      ..statusCode = HttpStatus.found
      ..headers.add('Location', url)
      ..close();
  }
}
