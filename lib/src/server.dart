import 'dart:async';
import 'dart:convert';
import 'dart:io';

import './path.dart';
import '../rmr.dart';

/// A **RMR** server that allows you to listen for requests.
class Server {
  final Map<String, Map<Path, List<RequestHandler>>> _routes = Map();

  /// Assign a list of listeners for a request on the specified [Path] with the
  /// specified method.
  Server on(String method, Path path, List<RequestHandler> callbacks) {
    method = method.toUpperCase();

    Map<Path, List<RequestHandler>> routes = this._routes[method] ?? Map();
    routes[path] = callbacks;
    this._routes[method] = routes;

    return this;
  }

  /// Handle an incoming request by finding routers that fit the request.
  void handleRequest(HttpRequest req, HttpResponse res) async {
    String method = req.method;
    Map<Path, List<RequestHandler>> routes = this._routes[method];
    if (routes == null) {
      res
        ..statusCode = HttpStatus.methodNotAllowed
        ..headers.contentType = ContentType.json
        ..write(
            jsonEncode({'error': 'The request method $method is not accepted'}))
        ..close();
      return;
    }

    final route = routes.entries.firstWhere(
        (entry) => entry.key.equals(req.requestedUri.path),
        orElse: () => null);

    if (route == null) {
      res
        ..statusCode = HttpStatus.notFound
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({
          'error': 'The request URL ${req.requestedUri.path} was not found'
        }))
        ..close();
      return;
    }

    RMR(req, res, route.key, route.value).next();
  }

  /// Listen for incoming requests on the specified address and port.
  Future<void> listen(InternetAddress address, int port,
      [void callback(HttpServer server)]) async {
    HttpServer server = await HttpServer.bind(address, port);
    if (callback != null) {
      callback(server);
    }

    await for (HttpRequest req in server) {
      handleRequest(req, req.response);
    }
  }

  /// Assign a new listener for `get` requests.
  Server get(Path path, List<RequestHandler> callbacks) =>
      on('get', path, callbacks);

  /// Assign a new listener for `head` requests.
  Server head(Path path, List<RequestHandler> callbacks) =>
      on('head', path, callbacks);

  /// Assign a new listener for `post` requests.
  Server post(Path path, List<RequestHandler> callbacks) =>
      on('post', path, callbacks);

  /// Assign a new listener for `put` requests.
  Server put(Path path, List<RequestHandler> callbacks) =>
      on('put', path, callbacks);

  /// Assign a new listener for `delete` requests.
  Server delete(Path path, List<RequestHandler> callbacks) =>
      on('delete', path, callbacks);

  /// Assign a new listener for `trace` requests.
  Server trace(Path path, List<RequestHandler> callbacks) =>
      on('trace', path, callbacks);

  /// Assign a new listener for `options` requests.
  Server options(Path path, List<RequestHandler> callbacks) =>
      on('options', path, callbacks);

  /// Assign a new listener for `connect` requests.
  Server connect(Path path, List<RequestHandler> callbacks) =>
      on('connect', path, callbacks);

  /// Assign a new listener for `patch` requests.
  Server patch(Path path, List<RequestHandler> callbacks) =>
      on('patch', path, callbacks);
}
