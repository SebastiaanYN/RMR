import './utils.dart';

/// A path for a route.
class Path {
  dynamic _path;

  /// Create a new [Path] from a [String] or [RegExp].
  Path(dynamic path) {
    if (path is String) {
      path = stripPath(path);
    } else if (path is! RegExp) {
      throw ArgumentError('Path must be a String or RegExp');
    }
    _path = path;
  }

  /// Check whether a path is equal to this path.
  bool equals(String path) {
    if (_path is RegExp) {
      return _path.firstMatch(stripPath(path)) != null;
    } else {
      return _path == stripPath(path);
    }
  }

  /// Get the matches that the paths have.
  ///
  /// This is only applicable if the [Path] is a [RegExp].
  Match getMatches(String path) {
    if (_path is RegExp) {
      return _path.firstMatch(stripPath(path));
    } else {
      return null;
    }
  }
}
