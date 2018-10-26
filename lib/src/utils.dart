/// Remove the slashes from the start and end of a path.
String stripPath(String path) {
  return path.replaceAll(RegExp(r'^\/+|\/+$'), '');
}
